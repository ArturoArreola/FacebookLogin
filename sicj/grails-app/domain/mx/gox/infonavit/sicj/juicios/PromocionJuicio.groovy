package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.admin.Usuario
import mx.gox.infonavit.sicj.catalogos.TipoDeParte

class PromocionJuicio implements Serializable {

    Juicio juicio
    TipoDeParte tipoDeParte
    Date fechaDePresentacion
    Date fechaDePromocion
    String resumenDeLaPromocion
    String observaciones
    String rutaArchivo
    Date fechaDeRegistro = new Date()
    Usuario usuarioQueRegistro

    static constraints = {
        juicio (nullable:false)
        tipoDeParte (nullable:false)
        fechaDePresentacion (nullable:false)
        fechaDePromocion (nullable:true)
        observaciones (nullable:true)
        resumenDeLaPromocion (nullable:true)
        rutaArchivo (nullable:false)
        fechaDeRegistro (nullable:false)
        usuarioQueRegistro (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_promocion_juicio', params:[sequence:'promocion_juicio_id_seq']
    }
}
