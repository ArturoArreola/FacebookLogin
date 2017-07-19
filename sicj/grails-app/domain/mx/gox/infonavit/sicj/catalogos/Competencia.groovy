package mx.gox.infonavit.sicj.catalogos

class Competencia implements Serializable{

    String nombre
    String descripcion
    
    static constraints = {
        nombre (nullable:false)
        descripcion (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_competencia', params:[sequence:'competencia_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
