package mx.gox.infonavit.sicj.catalogos

class RespuestaPregunta implements Serializable{

    String valorDeRespuesta
    
    static constraints = {
        valorDeRespuesta (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_respuesta', params:[sequence:'respuesta_id_seq']
    }
    
    String toString () {
        "${valorDeRespuesta}"
    }
}
