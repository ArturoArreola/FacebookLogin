package mx.gox.infonavit.sicj.catalogos

class EstadoDeJuicio implements Serializable{

    String nombre
    String descripcion
    
    static constraints = {
        nombre (nullable:false)
        descripcion (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_estado_de_juicio', params:[sequence:'estado_de_juicio_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
