package mx.gox.infonavit.sicj.juicios

import mx.gox.infonavit.sicj.admin.Delegacion
import mx.gox.infonavit.sicj.catalogos.Materia

class DocumentoArchivoHistorico implements Serializable {

    String nombreArchivo
    String rutaArchivo
    Materia materia
    Delegacion delegacion

    static constraints = {
        nombreArchivo (nullable:false)
        rutaArchivo (nullable:false)
        materia (nullable:false)
        delegacion (nullable:false)
    }
    
    static mapping = {
        id generator: 'sequence', column: 'id_documento_archivo_historico', params:[sequence:'documento_archivo_historico_id_seq']
    }
}
