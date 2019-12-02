//
//  UseCase.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/24.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

protocol UseCase {
    associatedtype Parameters
    associatedtype Success

    func execute(_ parameters: Parameters, completion: ((Result<Success, Error>) -> ())?)
    func cancel()
}

final class AnyUseCase<Parameters, Success>: UseCase {
    private let box: AnyUseCaseBox<Parameters, Success>

    init<T: UseCase>(_ base: T) where T.Parameters == Parameters, T.Success == Success {
        box = UseCaseBox<T>(base)
    }

    func execute(_ parameters: Parameters, completion: ((Result<Success, Error>) -> ())?) {
        box.execute(parameters, completion: completion)
    }
    func cancel() {
        box.cancel()
    }
}

private extension AnyUseCase {
    class AnyUseCaseBox<Parameters, Success> {
        func execute(_ parameters: Parameters, completion: ((Result<Success, Error>) -> ())?) {
            fatalError()
        }

        func cancel() {
            fatalError()
        }
    }

    final class UseCaseBox<T: UseCase>: AnyUseCaseBox<T.Parameters, T.Success> {
        private let base: T

        init(_ base: T) {
            self.base = base
        }

        override func execute(_ parameters: T.Parameters, completion: ((Result<T.Success, Error>) -> ())?) {
            base.execute(parameters, completion: completion)
        }

        override func cancel() {
            base.cancel()
        }
    }

}
