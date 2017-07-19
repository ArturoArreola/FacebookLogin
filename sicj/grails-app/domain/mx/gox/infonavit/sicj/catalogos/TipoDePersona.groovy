package mx.gox.infonavit.sicj.catalogos

class TipoDePersona implements Serializable {

    String nombre
    String descripcion
    
    static constraints = {
        nombre (nullable:false)
        descripcion (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_tipo_de_persona', params:[sequence:'tipo_de_persona_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
