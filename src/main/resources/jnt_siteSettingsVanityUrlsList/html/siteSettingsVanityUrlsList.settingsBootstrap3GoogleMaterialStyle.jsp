<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<c:set var="resourceReadOnly" value="${currentResource.moduleParams.readOnly}"/>
<template:include view="hidden.header"/>
<c:set var="isEmpty" value="true"/>
<c:set var="site" value="${renderContext.mainResource.node.resolveSite}"/>
<template:addResources type="javascript" resources="jquery.min.js"/>
<template:addResources type="javascript" resources="datatables/jquery.dataTables.js,i18n/jquery.dataTables-${currentResource.locale}.js,datatables/dataTables.bootstrap-ext.js,settings/dataTables.initializer.js"/>
<template:addResources type="css" resources="datatables/css/bootstrap-theme.css"/>

<template:addResources>
    <script type="text/javascript">
        $(document).ready(function () {
            dataTablesSettings.init('vanityUrlTable', 25, [], true, null);
         });
    </script>
</template:addResources>

<div class="page-header">
    <h2><fmt:message key="siteSettings.label.vanityURLSettings"/> - ${fn:escapeXml(site.displayableName)}</h2>
</div>

<div class="panel panel-default">
    <div class="panel-body">
        <form class="form-inline" action="<c:url value='${url.base}${renderContext.mainResource.node.path}.vanityURLSetting.html'/>">
            <div class="form-group label-floating">
                <label class="control-label" for="vanityUrlSearch">
                    <fmt:message key='label.urlmapping.filter'/>
                </label>
                <div class="input-group">
                    <input class="form-control" type="text" id="vanityUrlSearch" name="vanityUrlSearch" value="${param['vanityUrlSearch']}" />
                    <span class="input-group-btn">
                        <button class="btn btn-primary btn-sm" type="submit">
                            <fmt:message key="filters.label"/>
                        </button>
                    </span>
                </div>
            </div>
        </form>

        <table class="table table-striped table-bordered" id="vanityUrlTable">
            <thead>
                <tr>
                    <th><fmt:message key='label.urlmapping.mapping'/></th>
                    <th><fmt:message key='label.page'/></th>
                    <th><fmt:message key='label.urlmapping.lang'/></th>
                    <th><fmt:message key='label.urlmapping.active'/></th>
                    <th><fmt:message key='label.urlmapping.default'/></th>
                </tr>
            </thead>
            <tbody>
            <jsp:useBean id="vanityNodesID" class="java.util.HashMap" type="java.util.HashMap"/>
            <c:forEach items="${moduleMap.currentList}" var="subchild" begin="${moduleMap.begin}" end="${moduleMap.end}"
                       varStatus="status">
                <c:if test="${empty vanityNodesID[subchild.parent.identifier]}">
                    <tr class="${status.index % 2 == 0 ? 'evenLine' : 'oddLine'}">
                        <template:module node="${subchild}" view="${moduleMap.subNodesView}"
                                         editable="${moduleMap.editable && !resourceReadOnly}"/>
                    </tr>
                    <c:set var="isEmpty" value="false"/>
                    <c:set target="${vanityNodesID}" property="${subchild.parent.identifier}" value="${subchild.parent.identifier}"/>
                </c:if>
            </c:forEach>
            </tbody>
        </table>
        <c:if test="${not omitFormatting}">
            <div class="clear"></div>
        </c:if>
        <c:if test="${not empty moduleMap.emptyListMessage and (renderContext.editMode or moduleMap.forceEmptyListMessageDisplay) and isEmpty}">
            <div class="alert alert-info">${moduleMap.emptyListMessage}</div>
        </c:if>
        <template:include view="hidden.footer"/>
    </div>
</div>
