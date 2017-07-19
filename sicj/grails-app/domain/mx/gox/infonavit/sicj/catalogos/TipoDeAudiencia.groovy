package mx.gox.infonavit.sicj.catalogos

class TipoDeAudiencia implements Serializable{

    String nombre
    Materia materia
    boolean activo = true
    
    static constraints = {
        nombre (nullable:false)
        materia (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_tipo_de_audiencia', params:[sequence:'tipo_de_audiencia_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
