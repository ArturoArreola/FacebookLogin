package mx.gox.infonavit.sicj.catalogos

class PrestacionReclamada implements Serializable{

    String nombre
    String descripcion
    Materia materia
    
    static constraints = {
        nombre (nullable:false)
        descripcion (nullable:false)
        descripcion (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_prestacion_reclamada', params:[sequence:'prestacion_reclamada_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
