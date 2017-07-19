package mx.gox.infonavit.sicj.catalogos

class Estado implements Serializable{

    String nombre
   
    static constraints = {
        nombre(blank:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_estado', params:[sequence:'estado_id_seq']
    }
    
    String toString () {
        "${nombre}"
    }
}
