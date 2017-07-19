package mx.gox.infonavit.sicj.catalogos

class TipoDeAutoridad implements Serializable {

    String nombre
    boolean activo = true
    
    static constraints = {
        nombre (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_tipo_de_autoridad', params:[sequence:'tipo_de_autoridad_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
