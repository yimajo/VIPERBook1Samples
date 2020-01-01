//
//  UseCase.swift
//  Sample1A
//
//  Created by Yoshinori Imajo on 2019/11/24.
//  Copyright © 2019 Yoshinori Imajo. All rights reserved.
//

import Foundation

protocol UseCase where Failure: Error {
    associatedtype Parameters
    associatedtype Success
    associatedtype Failure

    func execute(
        _ parameters: Parameters,
        completion: ((Result<Success, Failure>) -> ())?
    )
    func cancel()
}

final class AnyUseCase<Parameters, Success, Failure: Error>: UseCase {
    private let box: AnyUseCaseBox<Parameters, Success, Failure>

    init<T: UseCase>(_ base: T) where T.Parameters == Parameters,
                                      T.Success == Success,
                                      T.Failure == Failure {
        box = UseCaseBox<T>(base)
    }

    func execute(
        _ parameters: Parameters,
        completion: ((Result<Success, Failure>) -> ())?
    ) {
        box.execute(parameters, completion: completion)
    }
    func cancel() {
        box.cancel()
    }
}

private extension AnyUseCase {
    class AnyUseCaseBox<Parameters, Success, Failure: Error> {
        func execute(
            _ parameters: Parameters,
            completion: ((Result<Success, Failure>) -> ())?)
        {
            fatalError()
        }

        func cancel() {
            fatalError()
        }
    }

    // Parameters, Success を UseCase のそれと合わせるために AnyUseCaseBox を継承する
    final class UseCaseBox<T: UseCase>
        : AnyUseCaseBox<T.Parameters, T.Success, T.Failure>
    {
        private let base: T

        init(_ base: T) {
            self.base = base
        }

        override func execute(
            _ parameters: T.Parameters,
            completion: ((Result<T.Success, T.Failure>) -> ())?)
        {
            base.execute(parameters, completion: completion)
        }

        override func cancel() {
            base.cancel()
        }
    }
}
