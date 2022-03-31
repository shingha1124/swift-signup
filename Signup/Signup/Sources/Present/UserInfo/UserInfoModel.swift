//
//  UserInfoModel.swift
//  Signup
//
//  Created by seongha shin on 2022/03/29.
//

import Foundation
import Combine

class UserInfoModel {
    struct Action {
        let selectBirthDate = PassthroughSubject<Date, Never>()
        let selectGender = PassthroughSubject<Gender, Never>()
        let enteredEmail = PassthroughSubject<String, Never>()
        let enteredPhoneNumber = PassthroughSubject<String, Never>()
        
        let presentDatePickerView = PassthroughSubject<Void, Never>()
    }
    
    struct State {
        let birthDate = CurrentValueSubject<Date?, Never>(nil)
        let gender = CurrentValueSubject<Gender, Never>(.female)
        let emailMessage = CurrentValueSubject<InputState, Never>(.none)
        let phoneNumberMessage = CurrentValueSubject<InputState, Never>(.none)
        
        let presentDatePickerView = PassthroughSubject<Date, Never>()
        let isEnabledNextButton = PassthroughSubject<Bool, Never>()
    }
    
    var cancellables = Set<AnyCancellable>()
    let action = Action()
    let state = State()
    
    init() {
        
        Publishers
            .Merge3(
                state.birthDate.map { _ in },
                state.emailMessage.map { _ in },
                state.phoneNumberMessage.map { _ in }
            )
            .map {
                if self.state.birthDate.value != nil,
                   self.state.emailMessage.value == .success,
                   self.state.phoneNumberMessage.value == .success {
                    return true
                }
                return false
            }
            .sink(receiveValue: self.state.isEnabledNextButton.send(_:))
            .store(in: &cancellables)
        
        action.presentDatePickerView
            .map { self.state.birthDate.value ?? Date.now }
            .sink(receiveValue: self.state.presentDatePickerView.send(_:))
            .store(in: &cancellables)
        
        action.selectBirthDate
            .sink(receiveValue: self.state.birthDate.send(_:))
            .store(in: &cancellables)
        
        action.selectGender
            .sink(receiveValue: self.state.gender.send(_:))
            .store(in: &cancellables)
        
        action.enteredEmail
            .map { CommonString.vaildateEmail($0) ? .success : .errorEmail }
            .sink(receiveValue: self.state.emailMessage.send(_:))
            .store(in: &cancellables)
        
        action.enteredPhoneNumber
            .map { CommonString.vaildatePhoneNumber($0) ? .success : .errorPhoneNumber }
            .sink(receiveValue: self.state.phoneNumberMessage.send(_:))
            .store(in: &cancellables)
    }
}

extension UserInfoModel {
    enum InputState {
        case none
        case success
        case errorEmail
        case errorPhoneNumber
    }
}
