package mx.gox.infonavit.sicj.juicios

class NotificacionJuicio implements Serializable{
    Juicio juicio
    String textoNotificacion
    String tipoNotificacion
    
    static constraints = {
        juicio (nullable:false)
        textoNotificacion (nullable:false)
        tipoNotificacion (inList: ['ERROR', 'WARNING'])
    }
    static mapping = {
        id generator: 'sequence', column: 'id_notificacion_juicio', params:[sequence:'notificacion_juicio_id_seq']
    }
}