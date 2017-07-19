package mx.gox.infonavit.sicj.catalogos

class PatrocinadorDelJuicio implements Serializable{
    
    String nombre
    boolean activo = true
    
    static constraints = {
        nombre (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_patrocinador_del_juicio', params:[sequence:'patrocinador_del_juicio_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
