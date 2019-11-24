//
//  UseCase.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/24.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

protocol UseCase {
    associatedtype Input
    associatedtype Output
    associatedtype Completion

    func execute(input: Input, completion: Completion) -> Output
}

class AnyUseCaseBox<Input, Output, Completion> {
    func execute(input: Input, completion: Completion) -> Output {
        fatalError()
    }
}

final class UseCaseBox<T: UseCase>: AnyUseCaseBox<T.Input, T.Output, T.Completion> {
    private let base: T

    init(_ base: T) {
        self.base = base
    }

    override func execute(input: T.Input, completion: T.Completion) -> T.Output {
        base.execute(input: input, completion: completion)
    }
}

final class AnyUseCase<Input, Output, Completion>: UseCase {
    private let box: AnyUseCaseBox<Input, Output, Completion>

    init<T: UseCase>(_ base: T) where T.Input == Input, T.Output == Output, T.Completion == Completion {
        box = UseCaseBox<T>(base)
    }

    func execute(input: Input, completion: Completion) -> Output {
        box.execute(input: input, completion: completion)
    }
}
