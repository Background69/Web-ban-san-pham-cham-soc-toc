<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<style>

    .store-sidebar {
        background: linear-gradient(145deg, #ffffff, #f9faf8);
        border-radius: 20px;
        padding: 0;
        box-shadow: 0 4px 20px rgba(44, 89, 64, 0.08);
        position: sticky;
        top: 100px;
        border: 1px solid #e8f1e1;
        overflow: hidden;
    }


    .sidebar-filter-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
        padding: 24px;
        border-bottom: 2px solid #e8f1e1;
        background: linear-gradient(135deg, #f5f8f2, #e8f1e1);
    }

    .sidebar-filter-title {
        display: flex;
        align-items: center;
        gap: 12px;
        font-size: 18px;
        font-weight: 700;
        color: #1a3d2e;
    }

    .sidebar-filter-title i {
        color: #89af63;
        animation: filterPulse 2s ease-in-out infinite;
    }

    @keyframes filterPulse {
        0%, 100% {
            transform: scale(1);
        }
        50% {
            transform: scale(1.08);
        }
    }

    .clear-filters {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 8px 16px;
        font-size: 13px;
        font-weight: 700;
        color: #fff;
        background: linear-gradient(135deg, #ff6b6b, #ff5252);
        border-radius: 20px;
        box-shadow: 0 4px 12px rgba(255, 82, 82, 0.25);
        text-decoration: none;
        transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .clear-filters:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 18px rgba(255, 82, 82, 0.35);
    }


    .store-sidebar form {
        padding: 20px 24px 24px;
    }


    .filter-accordion {
        border: none;
        border-radius: 14px;
        background: #fff;
        margin-bottom: 16px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        overflow: hidden;
        transition: box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1),
        transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .filter-accordion:hover {
        box-shadow: 0 4px 16px rgba(137, 175, 99, 0.15);
        transform: translateX(4px);
    }

    .filter-accordion-summary {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 10px;
        padding: 16px 18px;
        font-size: 14px;
        font-weight: 700;
        color: #1a3d2e;
        background: #fafbf9;
        cursor: pointer;
        user-select: none;
        list-style: none;
        transition: background 0.25s ease, color 0.25s ease;
    }

    .filter-accordion-summary::-webkit-details-marker {
        display: none;
    }

    .filter-accordion-summary::after {
        content: "\276F";
        font-size: 14px;
        color: #7d9a5f;
        transform: rotate(90deg);
        transition: transform 0.25s ease;
    }

    .filter-accordion-summary:hover {
        background: linear-gradient(135deg, #f5f8f2, #e8f1e1);
    }

    .filter-accordion[open] .filter-accordion-summary {
        background: linear-gradient(135deg, #89af63, #7d9a5f);
        color: #fff;
    }

    .filter-accordion[open] .filter-accordion-summary::after {
        transform: rotate(-90deg);
        color: #fff;
    }

    .filter-accordion-left {
        display: inline-flex;
        align-items: center;
        gap: 10px;
    }

    .filter-accordion-left i {
        color: #89af63;
        transition: color 0.25s ease;
    }

    .filter-accordion[open] .filter-accordion-left i {
        color: #fff;
    }


    .filter-badge {
        padding: 3px 10px;
        border-radius: 12px;
        font-size: 11px;
        font-weight: 700;
        color: #fff;
        background: linear-gradient(135deg, #ff6b6b, #ff5252);
        box-shadow: 0 2px 8px rgba(255, 82, 82, 0.3);
        animation: badgePop 0.3s ease;
    }

    @keyframes badgePop {
        0% {
            transform: scale(0);
        }
        50% {
            transform: scale(1.1);
        }
        100% {
            transform: scale(1);
        }
    }

    .filter-accordion-body {
        padding: 16px 18px;
        animation: accordionFade 0.25s ease;
    }

    @keyframes accordionFade {
        from {
            opacity: 0;
            transform: translateY(-6px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* ===== SEARCH INPUT ===== */
    .filter-search-wrap {
        position: relative;
        margin-bottom: 14px;
    }

    .filter-search-wrap i {
        position: absolute;
        left: 14px;
        top: 50%;
        transform: translateY(-50%);
        font-size: 14px;
        color: #89af63;
        transition: transform 0.2s ease, color 0.2s ease;
    }

    .filter-search {
        width: 100%;
        padding: 12px 14px 12px 38px;
        font-size: 13px;
        font-weight: 500;
        border: 2px solid #e8f1e1;
        border-radius: 12px;
        background: #fafbf9;
        transition: all 0.25s ease;
    }

    .filter-search::placeholder {
        color: #9aaa8f;
    }

    .filter-search:focus {
        border-color: #89af63;
        background: #fff;
        outline: none;
        box-shadow: 0 0 0 4px rgba(137, 175, 99, 0.15);
    }

    .filter-search-wrap:focus-within i {
        transform: translateY(-50%) scale(1.1);
        color: #2c5940;
    }

    /* ===== FILTER LIST + SCROLL ===== */
    .filter-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .filter-list li {
        margin-bottom: 6px;
    }

    .filter-list li:last-child {
        margin-bottom: 0;
    }

    .filter-scroll {
        max-height: 220px;
        overflow-y: auto;
        padding-right: 6px;
    }

    .filter-scroll::-webkit-scrollbar {
        width: 8px;
    }

    .filter-scroll::-webkit-scrollbar-track {
        background: #f5f8f2;
        border-radius: 10px;
    }

    .filter-scroll::-webkit-scrollbar-thumb {
        background: linear-gradient(180deg, #89af63, #7d9a5f);
        border-radius: 10px;
        border: 2px solid #f5f8f2;
    }


    .filter-row {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 10px 12px;
        border-radius: 10px;
        cursor: pointer;
        transition: all 0.2s ease;
    }

    .filter-row:hover {
        background: #f5f8f2;
        transform: translateX(4px);
    }

    .filter-row input[type="checkbox"],
    .filter-row input[type="radio"] {
        appearance: none;
        width: 20px;
        height: 20px;
        border: 2px solid #d7e3cf;
        background: #fff;
        border-radius: 6px;
        position: relative;
        flex-shrink: 0;
        transition: all 0.2s ease;
    }

    .filter-row input[type="radio"] {
        border-radius: 50%;
    }

    .filter-row input[type="checkbox"]:checked {
        background: linear-gradient(135deg, #89af63, #7d9a5f);
        border-color: #89af63;
    }

    .filter-row input[type="checkbox"]:checked::after {
        content: "\2713";
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        color: #fff;
        font-size: 14px;
        font-weight: bold;
    }

    .filter-row input[type="radio"]:checked {
        border-color: #89af63;
        border-width: 6px;
    }

    .filter-text {
        flex: 1;
        font-size: 14px;
        color: #4b5b4b;
        font-weight: 500;
        transition: color 0.2s ease;
    }

    .filter-row input:checked + .filter-text {
        color: #1a3d2e;
        font-weight: 700;
    }

    /* ===== PRICE RANGE ===== */
    .price-range select {
        width: 100%;
        padding: 14px 40px 14px 16px;
        font-size: 14px;
        font-weight: 600;
        border: 2px solid #e8f1e1;
        border-radius: 14px;
        background: #fafbf9;
        color: #2c5940;
        cursor: pointer;
        appearance: none;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='14' height='14' viewBox='0 0 14 14'%3E%3Cpath fill='%2389af63' d='M7 9L2 4h10z'/%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 16px center;
        transition: all 0.25s ease;
    }

    .price-range select:focus {
        border-color: #89af63;
        background: #fff;
        box-shadow: 0 0 0 4px rgba(137, 175, 99, 0.15);
        outline: none;
    }

    /* ===== RESPONSIVE ===== */
    @media (max-width: 992px) {
        .store-sidebar {
            position: static;
            margin-bottom: 30px;
        }
    }

    @media (max-width: 768px) {
        .store-sidebar {
            padding: 0;
        }

        .sidebar-filter-header {
            padding: 20px;
        }

        .store-sidebar form {
            padding: 16px 20px 20px;
        }

        .filter-accordion-summary {
            font-size: 13px;
        }

        .filter-text {
            font-size: 13px;
        }
    }

    @media (max-width: 576px) {
        .sidebar-filter-header {
            padding: 18px;
        }

        .store-sidebar form {
            padding: 14px 18px 18px;
        }

        .filter-accordion-summary {
            padding: 14px 16px;
        }
    }
</style>

<!-- ===== FILTER SIDEBAR ===== -->
<aside class="store-sidebar">
    <div class="sidebar-filter-header">
        <div class="sidebar-filter-title">
            <i class="fa-solid fa-sliders"></i> Bộ lọc
        </div>
        <a class="clear-filters" href="${clearFiltersUrl}">Xóa bộ lọc</a>
    </div>

    <form action="${pageContext.request.contextPath}/products" method="get" id="filterForm">
        <c:if test="${not empty searchTerm}">
            <input type="hidden" name="search" value="${searchTerm}">
        </c:if>
        <c:if test="${not empty param.sort}">
            <input type="hidden" name="sort" value="${param.sort}">
        </c:if>

        <!-- Filter Accordion 1: Danh mục -->
        <details class="filter-accordion" open>
            <summary class="filter-accordion-summary">
        <span class="filter-accordion-left">
          <i class="fa-solid fa-list"></i> Danh mục
        </span>
                <c:if test="${selectedCategoryCount > 0}">
                    <span class="filter-badge">${selectedCategoryCount}</span>
                </c:if>
            </summary>
            <div class="filter-accordion-body">
                <div class="filter-search-wrap">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input class="filter-search" type="text" placeholder="Tìm danh mục..."
                           oninput="filterList('categoryList', this.value)">
                </div>
                <ul id="categoryList" class="filter-list filter-scroll">
                    <c:forEach var="cat" items="${categories}">
                        <li>
                            <label class="filter-row">
                                <input type="checkbox" name="category" value="${cat.categorySlug}"
                                    ${selectedCategorySlugMap[cat.categorySlug] ? 'checked' : ''}
                                       onchange="document.getElementById('filterForm').submit()">
                                <span class="filter-text">${cat.categoryName}</span>
                            </label>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </details>

        <!-- Filter Accordion 2: Thương hiệu -->
        <details class="filter-accordion" open>
            <summary class="filter-accordion-summary">
        <span class="filter-accordion-left">
          <i class="fa-solid fa-tags"></i> Thương hiệu
        </span>
                <c:if test="${selectedBrandCount > 0}">
                    <span class="filter-badge">${selectedBrandCount}</span>
                </c:if>
            </summary>
            <div class="filter-accordion-body">
                <div class="filter-search-wrap">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input class="filter-search" type="text" placeholder="Tìm thương hiệu..."
                           oninput="filterList('brandList', this.value)">
                </div>
                <ul id="brandList" class="filter-list filter-scroll">
                    <c:forEach var="brand" items="${brands}">
                        <li>
                            <label class="filter-row">
                                <input type="checkbox" name="brand" value="${brand.brandSlug}"
                                    ${selectedBrandSlugMap[brand.brandSlug] ? 'checked' : ''}
                                       onchange="document.getElementById('filterForm').submit()">
                                <span class="filter-text">${brand.brandName}</span>
                            </label>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </details>

        <!-- Filter Accordion 3: Tình trạng tóc -->
        <details class="filter-accordion" open>
            <summary class="filter-accordion-summary">
        <span class="filter-accordion-left">
          <i class="fa-solid fa-leaf"></i> Tình trạng tóc
        </span>
                <c:if test="${fn:length(selectedConditionSlugMap) > 0}">
                    <span class="filter-badge">${fn:length(selectedConditionSlugMap)}</span>
                </c:if>
            </summary>
            <div class="filter-accordion-body">
                <div class="filter-search-wrap">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input class="filter-search" type="text" placeholder="Tìm tình trạng..."
                           oninput="filterList('conditionList', this.value)">
                </div>
                <ul id="conditionList" class="filter-list filter-scroll">
                    <c:forEach var="hc" items="${hairConditions}">
                        <li>
                            <label class="filter-row">
                                <input type="checkbox" name="hairCondition" value="${hc.conditionSlug}"
                                    ${selectedConditionSlugMap[hc.conditionSlug] ? 'checked' : ''}
                                       onchange="document.getElementById('filterForm').submit()">
                                <span class="filter-text">${hc.conditionName}</span>
                            </label>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </details>

        <!-- Filter Accordion 4: Đánh giá (Radio) -->
        <details class="filter-accordion" open>
            <summary class="filter-accordion-summary">
        <span class="filter-accordion-left">
          <i class="fa-solid fa-star"></i> Đánh giá
        </span>
                <c:if test="${not empty minRating}">
                    <span class="filter-badge">1</span>
                </c:if>
            </summary>
            <div class="filter-accordion-body">
                <ul class="filter-list">
                    <li>
                        <label class="filter-row">
                            <input type="radio" name="minRating" value=""
                            ${empty minRating ? 'checked' : ''}
                                   onchange="document.getElementById('filterForm').submit()">
                            <span class="filter-text">Tất cả</span>
                        </label>
                    </li>
                    <li>
                        <label class="filter-row">
                            <input type="radio" name="minRating" value="5"
                            ${minRating == '5' ? 'checked' : ''}
                                   onchange="document.getElementById('filterForm').submit()">
                            <span class="filter-text">⭐⭐⭐⭐⭐ 5 sao</span>
                        </label>
                    </li>
                    <li>
                        <label class="filter-row">
                            <input type="radio" name="minRating" value="4"
                            ${minRating == '4' ? 'checked' : ''}
                                   onchange="document.getElementById('filterForm').submit()">
                            <span class="filter-text">⭐⭐⭐⭐ 4 sao trở lên</span>
                        </label>
                    </li>
                    <li>
                        <label class="filter-row">
                            <input type="radio" name="minRating" value="3"
                            ${minRating == '3' ? 'checked' : ''}
                                   onchange="document.getElementById('filterForm').submit()">
                            <span class="filter-text">⭐⭐⭐ 3 sao trở lên</span>
                        </label>
                    </li>
                    <li>
                        <label class="filter-row">
                            <input type="radio" name="minRating" value="2"
                            ${minRating == '2' ? 'checked' : ''}
                                   onchange="document.getElementById('filterForm').submit()">
                            <span class="filter-text">⭐⭐ 2 sao trở lên</span>
                        </label>
                    </li>
                    <li>
                        <label class="filter-row">
                            <input type="radio" name="minRating" value="1"
                            ${minRating == '1' ? 'checked' : ''}
                                   onchange="document.getElementById('filterForm').submit()">
                            <span class="filter-text">⭐ 1 sao trở lên</span>
                        </label>
                    </li>
                </ul>
            </div>
        </details>

        <!-- Filter Accordion 5: Khoảng giá (Select) -->
        <details class="filter-accordion" open>
            <summary class="filter-accordion-summary">
        <span class="filter-accordion-left">
          <i class="fa-solid fa-money-bill"></i> Khoảng giá
        </span>
                <c:if test="${not empty param.priceRange}">
                    <span class="filter-badge">1</span>
                </c:if>
            </summary>
            <div class="filter-accordion-body">
                <div class="price-range">
                    <select name="priceRange" onchange="document.getElementById('filterForm').submit()">
                        <option value="">Tất cả</option>
                        <option value="0-200000" ${param.priceRange == '0-200000' ? 'selected' : ''}>Dưới 200.000₫
                        </option>
                        <option value="200000-500000" ${param.priceRange == '200000-500000' ? 'selected' : ''}>200.000₫
                            - 500.000₫
                        </option>
                        <option value="500000-1000000" ${param.priceRange == '500000-1000000' ? 'selected' : ''}>
                            500.000₫ - 1.000.000₫
                        </option>
                        <option value="1000000-" ${param.priceRange == '1000000-' ? 'selected' : ''}>Trên 1.000.000₫
                        </option>
                    </select>
                </div>
            </div>
        </details>
    </form>
</aside>

<script>
    function filterList(listId, query) {
        const list = document.getElementById(listId);
        if (!list) return;
        const needle = query.trim().toLowerCase();
        list.querySelectorAll('li').forEach(item => {
            const text = item.textContent.trim().toLowerCase();
            item.style.display = text.includes(needle) ? '' : 'none';
        });
    }
</script>
