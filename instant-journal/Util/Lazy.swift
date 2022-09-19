/// init内で遅延初期化が必要な場合などで利用する
/// - note: @Lazy()で呼び出す場合に、.initializedに変更しないとクラッシュするので多用に要注意
@propertyWrapper
enum Lazy<Value> {
    case uninitialized(() -> Value)
    case initialized(Value)

    init(wrappedValue: @autoclosure @escaping () -> Value) {
        self = .uninitialized(wrappedValue)
    }

    init() {
        self = .uninitialized({ fatalError() })
    }

    var wrappedValue: Value {
        mutating get {
            switch self {
            case .uninitialized(let initializer):
                let value = initializer()
                self = .initialized(value)
                return value
            case .initialized(let value):
                return value
            }
        }
        set {
            self = .initialized(newValue)
        }
    }
}
