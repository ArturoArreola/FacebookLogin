package mx.gox.infonavit.sicj.catalogos

class Materia implements Serializable{

    String nombre
    String descripcion
    String nombreCarpeta
    
    static constraints = {
        nombre (nullable:false)
        descripcion (nullable:false)
        nombreCarpeta (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_materia', params:[sequence:'materia_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
