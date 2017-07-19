<!DOCTYPE html>
<html>
    <head>
        <meta name="layout" content="inspinia" />
        <g:set var="entityName" value="${message(code: 'delegacion.label', default: 'Delegación')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="row wrapper border-bottom white-bg page-heading">
            <div class="col-sm-4">
                <h2>Consola de Administración</h2>
                <ol class="breadcrumb">
                    <li>
                        <a href="index.html">Catálogos</a>
                    </li>
                    <li class="active">
                        <strong>Administración de Catálogos</strong>
                    </li>
                </ol>
            </div>
        </div>
        <div>
            <g:render template="/templates/menuAdmin"/>
            <div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Catálogos Disponibles</h5>
                        </div>
                        <div class="ibox-content">
                            <div class="wrapper wrapper-content animated fadeInRight">
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="ibox">
                                            <div class="ibox-content product-box">
                                                <div class="product-desc">
                                                    <small class="text-muted">Catálogo</small>
                                                    <a href="#" class="product-name">Zona</a>
                                                    <div class="small m-t-xs">
                                                        Establece la catagorización de las delegaciones con base en el volúmen de juicios.
                                                    </div>
                                                    <div class="m-t text-righ">
                                                        <a href="/sicj/division/index" class="btn btn-xs btn-outline btn-primary">Ver <i class="fa fa-long-arrow-right"></i> </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="ibox">
                                            <div class="ibox-content product-box">
                                                <div class="product-desc">
                                                    <small class="text-muted">Catálogo</small>
                                                    <a href="#" class="product-name"> Delitos</a>
                                                    <div class="small m-t-xs">
                                                        Contiene el listado de delitos que podrán seleccionarse en el alta de juicios.
                                                    </div>
                                                    <div class="m-t text-righ">
                                                        <a href="/sicj/delito/index" class="btn btn-xs btn-outline btn-primary">Ver <i class="fa fa-long-arrow-right"></i> </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="ibox">
                                            <div class="ibox-content product-box">
                                                <div class="product-desc">
                                                    <small class="text-muted">Catálogo</small>
                                                    <a href="#" class="product-name"> Forma de Pago</a>
                                                    <div class="small m-t-xs">
                                                        Contiene el listado de formas de pago disponibles para marcar el juicio como pagado.
                                                    </div>
                                                    <div class="m-t text-righ">
                                                        <a href="/sicj/formaDePago/index" class="btn btn-xs btn-outline btn-primary">Ver <i class="fa fa-long-arrow-right"></i> </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="ibox">
                                            <div class="ibox-content product-box">
                                                <div class="product-desc">
                                                    <small class="text-muted">Catálogo</small>
                                                    <a href="#" class="product-name"> Motivo de Término</a>
                                                    <div class="small m-t-xs">
                                                        Contiene el listado de motivos disponibles por los que un juicio puede concluir.
                                                    </div>
                                                    <div class="m-t text-righ">
                                                        <a href="/sicj/motivoDeTermino/index" class="btn btn-xs btn-outline btn-primary">Ver <i class="fa fa-long-arrow-right"></i> </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="ibox">
                                            <div class="ibox-content product-box">
                                                <div class="product-desc">
                                                    <small class="text-muted">Catálogo</small>
                                                    <a href="#" class="product-name"> Patrocinadores del Juicio</a>
                                                    <div class="small m-t-xs">
                                                        Contiene el listado de  patrocinadores disponibles para el alta de juicios.
                                                    </div>
                                                    <div class="m-t text-righ">
                                                        <a href="/sicj/patrocinadorDelJuicio/index" class="btn btn-xs btn-outline btn-primary">Ver <i class="fa fa-long-arrow-right"></i> </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="ibox">
                                            <div class="ibox-content product-box">
                                                <div class="product-desc">
                                                    <small class="text-muted">Catálogo</small>
                                                    <a href="#" class="product-name"> Prestación Reclamada</a>
                                                    <div class="small m-t-xs">
                                                        Contiene el listado de prestaciones reclamadas disponibles en el alta de juicios.
                                                    </div>
                                                    <div class="m-t text-righ">
                                                        <a href="/sicj/prestacionReclamada/index" class="btn btn-xs btn-outline btn-primary">Ver <i class="fa fa-long-arrow-right"></i> </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="ibox">
                                            <div class="ibox-content product-box">
                                                <div class="product-desc">
                                                    <small class="text-muted">Catálogo</small>
                                                    <a href="#" class="product-name"> Tipos Asociados</a>
                                                    <div class="small m-t-xs">
                                                        Contiene el listado de tipos asociados disponibles en el alta de juicios en materia Laboral y Civil.
                                                    </div>
                                                    <div class="m-t text-righ">
                                                        <a href="/sicj/tipoAsociado/index" class="btn btn-xs btn-outline btn-primary">Ver <i class="fa fa-long-arrow-right"></i> </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="ibox">
                                            <div class="ibox-content product-box">
                                                <div class="product-desc">
                                                    <small class="text-muted">Catálogo</small>
                                                    <a href="#" class="product-name"> Tipos de Asignación</a>
                                                    <div class="small m-t-xs">
                                                        Contiene el listado de tipos de asignación disponibles en el alta de juicios.
                                                    </div>
                                                    <div class="m-t text-righ">
                                                        <a href="/sicj/tipoDeAsignacion/index" class="btn btn-xs btn-outline btn-primary">Ver <i class="fa fa-long-arrow-right"></i> </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-3">
                                        <div class="ibox">
                                            <div class="ibox-content product-box">
                                                <div class="product-desc">
                                                    <small class="text-muted">Catálogo</small>
                                                    <a href="#" class="product-name"> Tipos de Audiencia</a>
                                                    <div class="small m-t-xs">
                                                        Contiene el listado de tipos de audiencia disponibles en el registro de audiencias.
                                                    </div>
                                                    <div class="m-t text-righ">
                                                        <a href="/sicj/tipoDeAudiencia/index" class="btn btn-xs btn-outline btn-primary">Ver <i class="fa fa-long-arrow-right"></i> </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-3">
                                        <div class="ibox">
                                            <div class="ibox-content product-box">
                                                <div class="product-desc">
                                                    <small class="text-muted">Catálogo</small>
                                                    <a href="#" class="product-name"> Tipos de Autoridad</a>
                                                    <div class="small m-t-xs">
                                                        Contiene el listado de tipos de autoridad disponibles para el alta de audiencias y alta de jucios.
                                                    </div>
                                                    <div class="m-t text-righ">
                                                        <a href="/sicj/tipoDeAutoridad/index" class="btn btn-xs btn-outline btn-primary">Ver <i class="fa fa-long-arrow-right"></i> </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>