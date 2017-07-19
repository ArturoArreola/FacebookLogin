package mx.gox.infonavit.sicj.catalogos

class TipoDeProcedimiento implements Serializable {

    String nombre
    Materia materia
    
    static constraints = {
        nombre (nullable:false)
        materia (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_tipo_de_procedimiento', params:[sequence:'tipo_de_procedimiento_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
