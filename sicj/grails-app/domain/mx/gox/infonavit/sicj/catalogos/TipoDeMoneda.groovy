package mx.gox.infonavit.sicj.catalogos

class TipoDeMoneda implements Serializable {

    String nombre
    
    static constraints = {
        nombre (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_tipo_de_moneda', params:[sequence:'tipo_de_moneda_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
