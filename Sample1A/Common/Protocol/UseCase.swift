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
    // UseCaseを保持するboxを保持する
    private let box: AnyUseCaseBox<Parameters, Success, Failure>

    // UseCaseの実体を初期化時に渡しboxを作成してそれを保持する
    init<T: UseCase>(_ base: T) where T.Parameters == Parameters,
                                      T.Success == Success,
                                      T.Failure == Failure {
        box = UseCaseBox<T>(base)
    }

    // 外部から実行されると内部のboxにその処理を伝える
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

// AnyUseCaseさえ知ってればいい情報なためprivate extensionとしている
private extension AnyUseCase {

    // ジェネリクスの型パラメータParameters, Success, Failureを用いてメソッドをUseCaseと合わせる。
    // UseCaseBoxに継承させて型パラメータの決定を行う。
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

    // ジェネリクスの型パラメータとしてT: UseCaseを持つクラスとして定義。
    // AnyUseCaseBoxを継承しAnyUseCaseBoxのパラメータとUseCaseの型を合わせる。
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
