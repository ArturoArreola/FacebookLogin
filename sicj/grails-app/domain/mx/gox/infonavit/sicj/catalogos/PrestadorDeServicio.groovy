package mx.gox.infonavit.sicj.catalogos

class PrestadorDeServicio implements Serializable{

    String nombre
    boolean activo = true
    
    static constraints = {
        nombre (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_prestador_de_servicio', params:[sequence:'prestador_de_servicio_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
