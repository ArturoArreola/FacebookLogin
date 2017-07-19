package mx.gox.infonavit.sicj.catalogos

class Autoridad implements Serializable{

    Materia materia
    Ambito ambito
    TipoDeAutoridad tipoDeAutoridad
    String nombre
    boolean activo = true
    
    static constraints = {
        nombre (nullable:false)
        materia (nullable:false)
        ambito (nullable:false)
        tipoDeAutoridad (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_autoridad', params:[sequence:'autoridad_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
