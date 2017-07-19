<g:if test="${respuesta}">
    
    
        <g:if test="${respuesta?.pregunta}">
            
            <div class="pic-container" >
        <g:form  class="form-horizontal" id="workFlowForm" name="workFlowForm">    
            <% def pregunta = respuesta.pregunta.getAt(0)%>
            <center><small class="font-bold text-center">ETAPA: ${pregunta.etapaProcesal}</small></center>
            <div class="row">
                <center>${pregunta}</center>
            </div>
            <g:if test="${respuesta.respuestas}">
                <br />
                <input type="hidden" name="juicio" id="juicio" value="${juicioId}">
                <input type="hidden" name="pregunta" id="pregunta" value="${pregunta.id}">
                <input type="hidden" id="tipoDePregunta" value="${pregunta.tipoDePregunta.toString()}">
                <input type="hidden" id="preguntaObligatoria" value="${pregunta.obligatoria}">
                <g:if test="${pregunta.tipoDePregunta.toString().equals('FECHA')}">
                    <g:if test="${pregunta.requiereAudiencia}">
                        <input type="hidden" name="respuesta" id="respuesta" value="${respuesta.respuestas.getAt(0).id}">
                        <div class="row">
                            <div class="form-group">
                                <div class="col-md-12">
                                    <div class="form-group" id="data_1">
                                        <div id="fechaWorkFlow" class="input-group date datepicker">
                                            &nbsp;&nbsp;&nbsp;<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input style="width: 440px;text-align: center;" readOnly name="valorRespuesta" id="respuestaFecha" type="text" class="form-control" value="" onchange = "activarButon(this.value);">
                                        </div>
                                        <div class="col-md-12">
                                            </br>
                                            <div id="mensajeAudienciaWorkFlow" class='alert alert-warning' style="display: none;"><h4 align="center"><strong>¡Importante!</strong></br></h4><h5 align="center">Registre la audiencia antes de continuar</h5></div>
                                            <button name="registrarAudienciaWF" id="registraAudienciaWorkFlow" type="button" class="btn btn-success btn-block" value="${respuestaFecha}" onclick="$('#modalAltaAudienciaWF').modal('show');" style="display: none;">Registrar audiencia</button>
                                        </div>
                                    </div>  
                                </div>
                            </div>
                        </div>
                    </g:if>
                    <g:else>
                        <input type="hidden" name="respuesta" id="respuesta" value="${respuesta.respuestas.getAt(0).id}">
                        <div class="row">
                            <div class="form-group">
                                <div class="col-md-12">
                                    <div class="form-group" id="data_1">
                                        <div id="fechaWorkFlow" class="input-group date datepicker">
                                            &nbsp;&nbsp;&nbsp;<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input style="width: 440px;text-align: center;" readOnly name="valorRespuesta" id="respuestaFecha" type="text" class="form-control" value="">
                                        </div>
                                    </div>  
                                </div>
                            </div>
                        </div>
                    </g:else>
                </g:if>
                <g:elseif test="${pregunta.tipoDePregunta.toString().equals('TEXTO')}">
                    <input type="hidden" name="respuesta" id="respuesta" value="${respuesta.respuestas.getAt(0).id}">
                    <br />
                    <div class="row">
                        <div class="form-group">
                            <div class="col-md-12">
                                <div class="input-group">
                                    <input id="respuestaTexto" name='valorRespuesta' type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" maxlength="100"/> 
                                </div>  
                            </div>
                        </div>
                    </div>
                </g:elseif>
                <g:elseif test="${pregunta.tipoDePregunta.toString().equals('NUMERO')}">
                    <input type="hidden" name="respuesta" id="respuesta" value="${respuesta.respuestas.getAt(0).id}">
                    <br />
                    <div class="row">
                        <div class="form-group">
                            <div class="col-md-12">
                                <div class="input-group">
                                    <input id="respuestaTexto" name='valorRespuesta' type="text" class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase" maxlength="12" onKeyPress="return numbersonly(this, event)" /> 
                                </div>  
                            </div>
                        </div>
                    </div>
                </g:elseif>    
                <g:elseif test="${pregunta.tipoDePregunta.toString().equals('TEXTAREA')}">
                    <input type="hidden" name="respuesta" id="respuesta" value="${respuesta.respuestas.getAt(0).id}">
                    <br />
                    <div class="row">
                        <div class="form-group">
                            <div class="col-md-12">
                                <div class="input-group">
                                    <textarea rows="4" cols="80" style="width: 500px;" id="respuestaTextArea" name='valorRespuesta' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"></textarea> 
                                </div>  
                            </div>
                        </div>
                    </div>
                </g:elseif>
                <g:elseif test="${pregunta.tipoDePregunta.toString().equals('RADIO')}">
                    <br />
                    <div class="row">
                        <div class="form-group">
                            <div class="col-md-12">
                                <div class="input-group">
                                    <g:each var='resp' in='${respuesta.respuestas}'>
                                        <div class="radio radio-success radio-inline">
                                            <input type="radio" name="respuesta" id="respuestaRadio${resp.id}" value="${resp.id}" checked="">
                                            <label for="respuestaRadio${resp.id}">
                                                ${resp.valorDeRespuesta}
                                            </label>
                                        </div>
                                    </g:each>
                                </div>  
                            </div>
                        </div>
                    </div>
                </g:elseif>
                <g:elseif test="${pregunta.tipoDePregunta.toString().equals('CHECKBOX')}">
                    <input type="hidden" name="multiple" id="multiple" value="0">
                    <br />
                    <div class="row">
                        <div class="form-group">
                            <div class="col-md-12">
                                <div class="input-group">
                                    <g:each var='resp' in='${respuesta.respuestas}'>
                                        <div class="row">
                                            <div class="checkbox checkbox-success checkbox-circle col-md-12">
                                                <input type="checkbox" id="respuestaCheck${resp.id}" name="respuestaCheck" value="${resp.id}"/>
                                                <label for='respuestaCheck${resp.id}'>${resp.valorDeRespuesta}</label>
                                            </div>
                                        </div>
                                    </g:each>
                                </div>  
                            </div>
                        </div>
                    </div>
                </g:elseif>     
                <g:elseif test="${pregunta.tipoDePregunta.toString().equals('SELECT')}">    
                    <br />
                    <div class="row">
                        <div class="form-group">
                            <div class="col-md-12">
                                <div class="input-group">
                                    <g:select noSelection="['':'Elija una opción...']" data-placeholder="Elija una opción..." class="chosen-select" style="width:300px;" tabindex="2" name="respuesta" id="respuestaSelect" from="${respuesta.respuestas}" optionKey="id" />
                                </div>  
                            </div>
                        </div>
                    </div>
                </g:elseif>
                <g:if test="${pregunta.requiereSubirArchivo || pregunta.tipoDePregunta.toString().equals('ARCHIVO')}">
                    <g:if test="${pregunta.requiereSubirArchivo}">
                        <center>SUBIR DOCUMENTO</center>
                        <br />
                        <input type="hidden" id="auxiliar" value="SI">
                        <input type="hidden" name="datoAuxiliar" id="datoAuxiliar">
                    </g:if>
                    <g:else>
                        <input type="hidden" id="auxiliar" value="NO">
                        <input type="hidden" name="respuesta" id="respuesta" value="${respuesta.respuestas.getAt(0).id}">
                        <input type="hidden" name="valorRespuesta" id="valorRespuesta">
                    </g:else>
                    <div id="divDropzoneWF" class="col-lg-12">
                        <div id="actionsWF" class="row">
                            <div class="col-lg-6">
                                <span class="btn btn-primary btn-xs fileinput-button dz-clickable">
                                    <i class="glyphicon glyphicon-plus"></i>
                                    <span>Agregar Archivos</span>
                                </span>
                                <button type="submit" class="btn btn-success start btn-xs">
                                    <i class="glyphicon glyphicon-upload"></i>
                                    <span>Inicar Carga</span>
                                </button>
                            </div>
                            <div class="col-lg-6">
                                <span class="fileupload-process">
                                    <div id="total-progressWF" class="progress progress-striped active" style="background-color: #BDBDBD;" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
                                        <div class="progress-bar progress-bar-success" style="width:0%;" data-dz-uploadprogress=""></div>
                                    </div>
                                </span>
                            </div>
                        </div>
                        <br />
                        <div class="row">
                            <div class="table table-striped files" id="previewsWF">
                                <div id="templateWF" class="file-row">
                                    <div class="row">
                                        <div class="col-lg-offset-0 col-lg-6">
                                            <p><strong>Nombre del Archivo: </strong><span class="name" data-dz-name></span></p>
                                            <strong class="error text-danger" data-dz-errormessage></strong>
                                        </div>
                                        <div class="col-lg-4">
                                            <p><strong>Tamaño del Archivo: </strong><span class="badge badge-primary size" data-dz-size></span></p>
                                            <div class="progress progress-striped active" style="background-color: #BDBDBD;" role="progressbar" aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
                                                <div class="progress-bar progress-bar-primary" style="width:0%;" data-dz-uploadprogress></div>
                                            </div>
                                        </div>
                                        <div class="col-lg-2 text-center">
                                            <button data-dz-remove class="btn btn-danger btn-xs delete">
                                                <i class="glyphicon glyphicon-trash"></i>
                                                <span>Eliminar</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div id="mensajesDropzoneWF"></div>
                        </div>
                    </div>
                </g:if>
                <br />
                <center>OBSERVACIONES (Opcional)</center>
                <br />
                <div class="row">
                    <div class="form-group">
                        <div class="col-md-12">
                            <div class="input-group">
                                <textarea rows="4" cols="80" style="width: 500px;" id="observaciones" name='observaciones' class="form-control" onBlur="this.value=this.value.toUpperCase();" style="text-transform: uppercase"></textarea> 
                            </div> 
                        </div>
                    </div>
                </div>    
                <br />
                <br />
                <div class="row">
                    <div class="col-md-12">
                        <div class="form-group">
                            <button name="botonGuardar" type="submit" class="btn btn-primary">Guardar</button>
                            <!--<g:submitToRemote onSuccess="inicializarControles();" onFailure="alert('algo fallo');" update="divPreguntas" class="btn btn-primary" url="[controller: 'juicio',action: 'registrarAvanceWorkFlow']" method="POST" value="Guardar y Continuar"/>-->
                        </div>
                    </div>
                </div>
            </g:if> 
        </g:form>
     </div>
            </g:if>
  
    
    
    
    <g:elseif test="${respuesta?.terminaProcedimiento}">
        <center>
            <div class="alert alert-info">
                ${respuesta.mensaje}
            </div>
        </center>
    </g:elseif>
    <g:elseif test="${respuesta?.error}">
        <center>
            <div class="alert alert-danger">
                ${respuesta.mensaje}
            </div>
        </center>
    </g:elseif> 
</g:if>
<style>
    pic-container {
        overflow-y: scroll;
        overflow-x:hidden;
    }
</style>