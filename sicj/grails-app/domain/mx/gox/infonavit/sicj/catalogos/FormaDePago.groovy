package mx.gox.infonavit.sicj.catalogos

class FormaDePago implements Serializable{

    String nombre
    boolean activo
    
    static constraints = {
        nombre (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_forma_de_pago', params:[sequence:'forma_de_pago_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
