package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.admin.Usuario
import mx.gox.infonavit.sicj.catalogos.TipoDeParte

class AcuerdoJuicio implements Serializable {

    Juicio juicio
    Date fechaDePublicacion
    String observaciones
    String rutaArchivo
    Date fechaDeRegistro = new Date()
    Usuario usuarioQueRegistro

    static constraints = {
        juicio (nullable:false)
        observaciones (nullable:false)
        rutaArchivo (nullable:false)
        fechaDePublicacion (nullable:false)
        fechaDeRegistro (nullable:false)
        usuarioQueRegistro (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_acuerdo_juicio', params:[sequence:'acuerdo_juicio_id_seq']
    }
}
