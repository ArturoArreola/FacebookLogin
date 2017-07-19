package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.admin.Usuario
import mx.gox.infonavit.sicj.catalogos.Persona
import mx.gox.infonavit.sicj.catalogos.TipoDeParte

class ActorJuicio implements Serializable {

    Persona persona
    Juicio juicio
    TipoDeParte tipoDeParte
    Date fechaDeRegistro = new Date()
    Usuario usuarioQueRegistro
    int cantidadDemandada = 0
    boolean haDesistido = false

    static constraints = {
        persona (nullable:false)
        juicio (nullable:false)
        tipoDeParte (nullable:false)
        fechaDeRegistro (nullable:false)
        usuarioQueRegistro (nullable:false)
        cantidadDemandada (nullable:true)
    }
    
    static mapping = {
        id composite : ['persona', 'juicio']
    }
}
