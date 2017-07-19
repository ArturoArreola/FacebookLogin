<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'juicio.label', default: 'Juicio')}" />
        <title>Control de Juicios</title>
        <!-- Sweet Alert -->
        <g:external dir="assets/plugins/sweetalert" file="sweetalert.css" />
        <!-- Sweet alert -->
        <g:external dir="assets/plugins/sweetalert" file="sweetalert.min.js" />
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Control de Juicios</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="/sicj/juicio/search">Juicios</a>
                    </li>
                    <li class="active">
                        <strong>Archivo Histórico</strong>
                    </li>
                </ol>
            </div>
        </div>
        <div>
            <g:render template="/templates/menuJuicios"/>
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Archivo Histórico Antes de 2014</h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <g:if test="${flash.error}">
                                <center>
                                    <div class="alert alert-danger alert-dismissable">
                                        <button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
                                        ${flash.error}
                                    </div>
                                </center>
                            </g:if> 
                            <div class="row">
                                <div class="col-lg-12">
                                    <g:if test="${documentos}">
                                        <g:each in='${documentos}' status='i' var='documento'>
                                            <% def extension = (documento?.nombreArchivo?.substring(documento?.nombreArchivo?.lastIndexOf(".") + 1)).toLowerCase() %>
                                            <div class="file-box">
                                                <div class="file">
                                                    <g:link action="descargarHistorico" id="${documento.id}">
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
                                                        <div class="file-name" style="height: 75px; text-align: center;">
                                                            ${documento.delegacion}
                                                            <br/>
                                                            <small><strong>${documento.materia}</strong></small><br/>
                                                            <small> ${documento.nombreArchivo}</small>
                                                        </div>
                                                    </g:link>
                                                </div>
                                            </div>
                                        </g:each>    
                                    </g:if>
                                    <g:else>
                                        No se han agregado archivos a este asunto.
                                    </g:else>    
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
