package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.admin.Usuario

class PagoJuicioRezago implements Serializable{

    long montoDelPago
    int numeroDePago
    Juicio juicio
    Date fechaDelPago
    Date fechaDeRegistro =  new Date()
    Usuario usuarioQueRegistro
    
    static belongsTo = [Juicio]
       
    static constraints = {
        juicio(nullable:false)
        fechaDelPago(nullable:false)
        numeroDePago (min: 1, max: 4)
        fechaDeRegistro (nullable: false)
        usuarioQueRegistro (nullable: false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_pago_juicio_rezago', params:[sequence:'pago_juicio_rezago_id_seq']
    }
}
