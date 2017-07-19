package mx.gox.infonavit.sicj.catalogos

class TipoDeParte implements Serializable {

    String nombre
    
    static constraints = {
        nombre (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_tipo_de_parte', params:[sequence:'tipo_de_parte_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
