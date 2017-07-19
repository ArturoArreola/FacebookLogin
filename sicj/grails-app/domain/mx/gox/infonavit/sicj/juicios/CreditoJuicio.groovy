package mx.gox.infonavit.sicj.juicios

class CreditoJuicio implements Serializable {

    String numeroDeCredito
    Juicio juicio
    
    static constraints = {
        numeroDeCredito (nullable:false)
        juicio (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_credito_juicio', params:[sequence:'credito_juicio_id_seq']
    }
    
    String toString () {
        "${numeroDeCredito}"
    }
}
