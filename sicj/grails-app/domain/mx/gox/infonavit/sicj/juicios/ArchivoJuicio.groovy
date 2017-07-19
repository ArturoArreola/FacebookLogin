package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.admin.Usuario

class ArchivoJuicio implements Serializable {

    Juicio juicio
    String nombreArchivo
    String rutaArchivo
    String observaciones
    Date fechaDeSubida = new Date()
    Usuario subidoPor

    static constraints = {
        juicio (nullable:false)
        nombreArchivo (nullable:false)
        rutaArchivo (nullable:false)
        observaciones (nullable:false)
        fechaDeSubida (nullable:false)
        subidoPor (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_archivo_juicio', params:[sequence:'archivo_juicio_id_seq']
    }
}
