import UIKit

// Definindo a estrutura Product
struct Product {
    let id: Int
    let name: String
    let price: Double
}

// Definindo a enumeração OrderStatus
enum OrderStatus {
    case pending
    case shipped
    case delivered
}

// Definindo a classe Order
class Order {
    let id: Int
    var products: [Product]
    var status: OrderStatus

    init(id: Int, products: [Product], status: OrderStatus) {
        self.id = id
        self.products = products
        self.status = status
    }

    func totalPrice() -> Double {
        let totalPrice = products.reduce(0.0) { $0 + $1.price }
        return totalPrice
    }
}

// Função de fechamento (closure) para atualizar o status do pedido
let updateOrderStatus: (Order, OrderStatus) -> () = { order, newStatus in
    order.status = newStatus
    print("Pedido \(order.id) atualizado para \(newStatus)")
}

// Função para processar um pedido com concorrência
func processOrder(_ order: Order, delaySeconds: Double) {
    DispatchQueue.global().async {
        sleep(UInt32(delaySeconds))
        updateOrderStatus(order, .shipped)
    }
}

// Função principal para demonstrar o sistema
func main() {
    let product1 = Product(id: 1, name: "Produto A", price: 20.0)
    let product2 = Product(id: 2, name: "Produto B", price: 30.0)

    let order1 = Order(id: 101, products: [product1, product2], status: .pending)
    let order2 = Order(id: 102, products: [product2], status: .pending)

    processOrder(order1, delaySeconds: 2.0)
    processOrder(order2, delaySeconds: 1.0)

    // Aguarda um tempo para permitir que as threads concorrentes atualizem o status
    sleep(3)

    print("Pedido 101 - Status: \(order1.status), Preço Total: \(order1.totalPrice())")
    print("Pedido 102 - Status: \(order2.status), Preço Total: \(order2.totalPrice())")
}

// Chamando a função principal para testar o sistema
main()
