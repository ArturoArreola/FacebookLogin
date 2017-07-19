<g:if test="${respuesta}">
    <div class="ibox-content" id="ibox-content">
        <div class="row text-center">
            <g:link action='imprimitHistorialDelJuicio' id='${juicio.id}' class="btn btn-primary btn-xs">Exportar</g:link>
            </div>
        <g:each var='resp' in='${respuesta}'>
            <div id="vertical-timeline" class="vertical-container dark-timeline">
                <div class="vertical-timeline-block">
                    <g:if test="${resp.preguntaAtendida.tipoDePregunta.toString().equals('FECHA')}">
                        <div class="vertical-timeline-icon navy-bg">
                            <i class="fa fa-calendar"></i>
                        </g:if>
                        <g:elseif test="${resp.preguntaAtendida.tipoDePregunta.toString().equals('TEXTAREA') || resp.preguntaAtendida.tipoDePregunta.toString().equals('TEXTO')}">
                            <div class="vertical-timeline-icon blue-bg">
                                <i class="fa fa-align-justify"></i>
                            </g:elseif>
                            <g:elseif test="${resp.preguntaAtendida.tipoDePregunta.toString().equals('RADIO') || resp.preguntaAtendida.tipoDePregunta.toString().equals('CHECKBOX')}">
                                <div class="vertical-timeline-icon yellow-bg">
                                    <i class="fa fa-question"></i>
                                </g:elseif>
                                <g:elseif test="${resp.preguntaAtendida.tipoDePregunta.toString().equals('SELECT')}">
                                    <div class="vertical-timeline-icon lazur-bg">
                                        <i class="fa fa-list-ul"></i>
                                    </g:elseif>
                                    <g:elseif test="${resp.preguntaAtendida.tipoDePregunta.toString().equals('NUMERO')}">
                                        <div class="vertical-timeline-icon black-bg">
                                            <i class="fa fa-slack"></i>
                                        </g:elseif>
                                        <g:elseif test="${resp.preguntaAtendida.tipoDePregunta.toString().equals('ARCHIVO')}">
                                            <div class="vertical-timeline-icon red-bg">
                                                <i class="fa fa-file-o"></i>
                                            </g:elseif>
                                        </div>
                                        <div class="vertical-timeline-content">
                                            <span class="badge">${resp.preguntaAtendida.etapaProcesal}</span>
                                            <h4>${resp.preguntaAtendida}</h4>
                                            <p>
                                                <g:if test="${resp.preguntaAtendida.tipoDePregunta.toString().equals('ARCHIVO')}">
                                                    <g:if test="${!resp.valorRespuesta.equals('NO SE PROPORCIONO EL DATO')}">  
                                                        <% def archivo = mx.gox.infonavit.sicj.juicios.ArchivoJuicio.get(resp.valorRespuesta as long) %>
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
                                                                </div>
                                                            </g:link>
                                                        </div>
                                                    </div>
                                                </g:if>
                                            </g:if>
                                            <g:else>
                                                <g:if test="${resp.valorRespuesta}">
                                                    <b>Respuesta: </b> ${resp.valorRespuesta}
                                                </g:if>
                                                <g:else>
                                                    <b>Respuesta: </b> ${resp.respuesta}
                                                </g:else>
                                                <g:if test="${resp.datoAuxiliar}">
                                                    <g:if test="${resp.preguntaAtendida.requiereSubirArchivo}">
                                                        <% def archivoAuxiliar = mx.gox.infonavit.sicj.juicios.ArchivoJuicio.get(resp.datoAuxiliar as long) %>
                                                        <% def extensionArchivoAuxiliar = (archivoAuxiliar?.nombreArchivo?.substring(archivoAuxiliar?.nombreArchivo?.lastIndexOf(".") + 1)).toLowerCase() %>
                                                        <div class="file-box">
                                                            <div class="file">
                                                                <g:link action="descargarArchivo" id="${archivoAuxiliar.id}">
                                                                    <div class="icon">
                                                                        <g:if test="${extensionArchivoAuxiliar.equals('pdf')}">
                                                                            <center><img src="/sicj/assets/pdf_file.png" class="img-responsive" /></center>
                                                                            </g:if>
                                                                            <g:elseif test="${extensionArchivoAuxiliar.equals('doc') || extensionArchivoAuxiliar.equals('docx')}">
                                                                            <center><img src="/sicj/assets/word_file.png" class="img-responsive"/></center>
                                                                            </g:elseif>
                                                                            <g:elseif test="${extensionArchivoAuxiliar.equals('xls') || extensionArchivoAuxiliar.equals('xlsx')}">
                                                                            <center><img src="/sicj/assets/excel_file.png" class="img-responsive"/></center>
                                                                            </g:elseif>
                                                                            <g:elseif test="${extensionArchivoAuxiliar.equals('csv')}">
                                                                            <center><img src="/sicj/assets/csv.png" class="img-responsive"/></center>
                                                                            </g:elseif>
                                                                            <g:elseif test="${extensionArchivoAuxiliar.equals('jpg')}">
                                                                            <center><img src="/sicj/assets/jpg_file.png" class="img-responsive"/></center>
                                                                            </g:elseif>
                                                                            <g:elseif test="${extensionArchivoAuxiliar.equals('png')}">
                                                                            <center><img src="/sicj/assets/png_file.png" class="img-responsive"/></center>
                                                                            </g:elseif>
                                                                    </div>
                                                                    <div class="file-name">
                                                                        ${archivoAuxiliar.nombreArchivo}
                                                                    </div>
                                                                </g:link>
                                                            </div>
                                                        </div>
                                                    </g:if>
                                                </g:if>
                                            </g:else>
                                            <br />     
                                            <b>Observaciones: </b> ${resp.observaciones}
                                            </p>
                                            <span class="vertical-date">
                                                <small>Usuario que respondió: ${resp.usuarioQueResponde}</small> <br/>
                                                <small>${resp.fechaDeRespuesta}</small>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </g:each>
                        </div>
                    </g:if>