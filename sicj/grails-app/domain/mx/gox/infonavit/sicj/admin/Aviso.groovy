package mx.gox.infonavit.sicj.admin

class Aviso implements Serializable{

    String textoAviso
    String tituloAviso
    boolean activo = true
    Usuario usuarioQueRegistro
    Date fechaDePublicacion =  new Date()
    Date fechaLimite
    
    static constraints = {
        tituloAviso (nullable:false)
        textoAviso (nullable:false, maxSize: 1000)
        usuarioQueRegistro (nullable:false)
        fechaDePublicacion (nullable:false)
        fechaLimite (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_aviso', params:[sequence:'aviso_id_seq']
    }
}
