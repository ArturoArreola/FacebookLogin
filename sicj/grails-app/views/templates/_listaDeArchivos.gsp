<div class="row">
    <div class="col-lg-12">
        <g:if test="${archivos}">
            <g:each in='${archivos}' status='i' var='archivo'>
                <% def extension = (archivo?.nombreArchivo?.substring(archivo?.nombreArchivo?.lastIndexOf(".") + 1)).toLowerCase() %>
                <div class="file-box">
                    <div class="file">
                        <g:link action="descargarArchivo" id="${archivo.id}">
                            <div class="icon">
                                <g:if test="${extension.equals('pdf')}">
                                    <center><img src="/sicj/assets/pdf_file.png" class="img-responsive" /></center>
                                    </g:if>
                                    <g:elseif test="${extension.equals('doc') || extension.equals('docx')}">
                                    <center><img src="/sicj/assets/word_file.png" class="img-responsive" /></center>
                                    </g:elseif>
                                    <g:elseif test="${extension.equals('xls') || extension.equals('xlsx')}">
                                    <center><img src="/sicj/assets/excel_file.png" class="img-responsive" /></center>
                                    </g:elseif>
                                    <g:elseif test="${extension.equals('csv')}">
                                    <center><img src="/sicj/assets/csv.png" class="img-responsive" /></center>
                                    </g:elseif>
                                    <g:elseif test="${extension.equals('jpg')}">
                                    <center><img src="/sicj/assets/jpg_file.png" class="img-responsive" /></center>
                                    </g:elseif>
                                    <g:elseif test="${extension.equals('png')}">
                                    <center><img src="/sicj/assets/png_file.png" class="img-responsive" /></center>
                                    </g:elseif>
                            </div>
                            <div class="file-name">
                                ${archivo.nombreArchivo}
                                <br/>
                                <small>${archivo.fechaDeSubida}</small>
                                <small>${archivo.subidoPor}</small>
                            </div>
                        </g:link>
                        <g:if test="${juicio.estadoDeJuicio.id == 1}">
                            <button class="btn btn-danger btn-xs" style="width: 100%;" onclick="eliminarArchivo(${juicio.id},${archivo.id});">Eliminar Archivo</button>
                        </g:if>
                    </div>
                </div>
            </g:each>    
        </g:if>
        <g:else>
            No se han agregado archivos a este asunto.
        </g:else>    
    </div>
</div>