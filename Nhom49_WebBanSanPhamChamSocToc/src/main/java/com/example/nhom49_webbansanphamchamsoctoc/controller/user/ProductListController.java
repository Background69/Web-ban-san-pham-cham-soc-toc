package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.dao.BrandDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.CategoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.HairConditionDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Brand;
import com.example.nhom49_webbansanphamchamsoctoc.model.Category;
import com.example.nhom49_webbansanphamchamsoctoc.model.HairCondition;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductVariant;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.math.RoundingMode;

@WebServlet(name = "ProductListController", urlPatterns = {"/products", "/store", "/search", "/ProductList"})
public class ProductListController extends HttpServlet {
    private static final int PAGE_SIZE = 12;

    private ProductService productService;
    private CategoryDAO categoryDAO;
    private BrandDAO brandDAO;
    private HairConditionDAO hairConditionDAO;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        categoryDAO = new CategoryDAO();
        brandDAO = new BrandDAO();
        hairConditionDAO = new HairConditionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<String> categoryParams = getMultiParams(request, "category");
        List<String> brandParams = getMultiParams(request, "brand");
        List<String> hairConditionParams = getMultiParams(request, "hairCondition");
        String search = normalizeParam(request.getParameter("search"));
        if (search == null) {
            search = normalizeParam(request.getParameter("q"));
        }
        if (search == null) {
            search = normalizeParam(request.getParameter("keyword"));
        }
        String priceRange = normalizeParam(request.getParameter("priceRange"));
        String sort = normalizeParam(request.getParameter("sort"));
        Integer minRating = parseMinRating(request.getParameter("minRating"));

        int page = parsePage(request.getParameter("page"));

        Set<Integer> selectedCategoryIds = new LinkedHashSet<>();
        Set<String> selectedCategorySlugs = new LinkedHashSet<>();
        Category currentCategory = null;
        for (String value : categoryParams) {
            Category category = resolveCategory(value);
            if (category != null) {
                selectedCategoryIds.add(category.getCategoryId());
                selectedCategorySlugs.add(category.getCategorySlug());
                currentCategory = category;
            }
        }
        if (selectedCategoryIds.size() != 1) {
            currentCategory = null;
        }

        Set<Integer> selectedBrandIds = new LinkedHashSet<>();
        Set<String> selectedBrandSlugs = new LinkedHashSet<>();
        Brand currentBrand = null;
        for (String value : brandParams) {
            Brand brand = resolveBrand(value);
            if (brand != null) {
                selectedBrandIds.add(brand.getBrandId());
                selectedBrandSlugs.add(brand.getBrandSlug());
                currentBrand = brand;
            }
        }
        if (selectedBrandIds.size() != 1) {
            currentBrand = null;
        }

        List<HairCondition> hairConditions = hairConditionDAO.findAll();
        Map<String, HairCondition> hairConditionBySlug = new HashMap<>();
        Map<Integer, HairCondition> hairConditionById = new HashMap<>();
        for (HairCondition condition : hairConditions) {
            hairConditionBySlug.put(condition.getConditionSlug(), condition);
            hairConditionById.put(condition.getConditionId(), condition);
        }
        Set<Integer> selectedConditionIds = new LinkedHashSet<>();
        Set<String> selectedConditionSlugs = new LinkedHashSet<>();
        for (String value : hairConditionParams) {
            HairCondition condition = hairConditionBySlug.get(value);
            if (condition == null) {
                Integer parsedId = parseOptionalInt(value);
                if (parsedId != null) {
                    condition = hairConditionById.get(parsedId);
                }
            }
            if (condition != null) {
                selectedConditionIds.add(condition.getConditionId());
                selectedConditionSlugs.add(condition.getConditionSlug());
            }
        }

        List<Product> products = search != null
                ? productService.searchProductsExcludingOnSale(search)
                : productService.getAllProductsExcludingOnSale();

        List<Product> filtered = new ArrayList<>();
        BigDecimal minPrice = null;
        BigDecimal maxPrice = null;
        if (priceRange != null) {
            BigDecimal[] range = parsePriceRange(priceRange);
            minPrice = range[0];
            maxPrice = range[1];
        }

        for (Product product : products) {
            if (!selectedCategoryIds.isEmpty()) {
                Integer categoryId = product.getCategoryId();
                if (categoryId == null || !selectedCategoryIds.contains(categoryId)) {
                    continue;
                }
            }
            if (!selectedBrandIds.isEmpty()) {
                Integer brandId = product.getBrandId();
                if (brandId == null || !selectedBrandIds.contains(brandId)) {
                    continue;
                }
            }
            if (minPrice != null || maxPrice != null) {
                BigDecimal productPrice = getProductPrice(product);
                if (productPrice == null) {
                    continue;
                }
                if (minPrice != null && productPrice.compareTo(minPrice) < 0) {
                    continue;
                }
                if (maxPrice != null && productPrice.compareTo(maxPrice) > 0) {
                    continue;
                }
            }
            if (minRating != null) {
                BigDecimal rating = product.getAverageRating() != null ? product.getAverageRating() : BigDecimal.ZERO;
                if (rating.compareTo(BigDecimal.valueOf(minRating)) < 0) {
                    continue;
                }
            }
            filtered.add(product);
        }

        Map<Integer, List<HairCondition>> conditionMap = Map.of();
        if (!filtered.isEmpty()) {
            List<Integer> productIds = filtered.stream().map(Product::getProductId).toList();
            conditionMap = hairConditionDAO.findByProductIds(productIds);
        }
        List<Product> conditionFiltered = new ArrayList<>();
        for (Product product : filtered) {
            List<HairCondition> productConditions =
                    conditionMap.getOrDefault(product.getProductId(), List.of());
            product.setHairConditions(productConditions);
            if (!selectedConditionIds.isEmpty()) {
                boolean matches = false;
                for (HairCondition condition : productConditions) {
                    if (selectedConditionIds.contains(condition.getConditionId())) {
                        matches = true;
                        break;
                    }
                }
                if (!matches) {
                    continue;
                }
            }
            conditionFiltered.add(product);
        }
        filtered = conditionFiltered;

        applySorting(filtered, sort);

        int totalProducts = filtered.size();
        int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);
        if (totalPages > 0 && page > totalPages) {
            page = totalPages;
        }

        List<Product> pagedProducts = paginate(filtered, page, PAGE_SIZE);

        request.setAttribute("products", pagedProducts);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("categories", categoryDAO.findAll());
        request.setAttribute("brands", brandDAO.findAll());
        request.setAttribute("hairConditions", hairConditions);
        request.setAttribute("selectedCategorySlugsCsv", String.join(",", selectedCategorySlugs));
        request.setAttribute("selectedBrandSlugsCsv", String.join(",", selectedBrandSlugs));
        request.setAttribute("selectedConditionSlugsCsv", String.join(",", selectedConditionSlugs));
        request.setAttribute("selectedCategorySlugMap", toSlugMap(selectedCategorySlugs));
        request.setAttribute("selectedBrandSlugMap", toSlugMap(selectedBrandSlugs));
        request.setAttribute("selectedConditionSlugMap", toSlugMap(selectedConditionSlugs));
        request.setAttribute("selectedCategoryCount", selectedCategoryIds.size());
        request.setAttribute("selectedBrandCount", selectedBrandIds.size());
        request.setAttribute("minRating", minRating);
        request.setAttribute("currentCategory", currentCategory);
        request.setAttribute("currentBrand", currentBrand);
        request.setAttribute("pageTitle", buildPageTitle(currentCategory, currentBrand, search));
        request.setAttribute("queryString", buildQueryString(request, Set.of("sort", "page")));
        request.setAttribute("paginationQueryString", buildQueryString(request, Set.of("page")));

        request.getRequestDispatcher("/user/product/product-list.jsp").forward(request, response);
    }

    private int parsePage(String pageParam) {
        if (pageParam == null) {
            return 1;
        }
        try {
            int page = Integer.parseInt(pageParam);
            return Math.max(page, 1);
        } catch (NumberFormatException e) {
            return 1;
        }
    }

    private String normalizeParam(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private List<String> getMultiParams(HttpServletRequest request, String key) {
        String[] values = request.getParameterValues(key);
        List<String> normalized = new ArrayList<>();
        if (values == null || values.length == 0) {
            String single = normalizeParam(request.getParameter(key));
            if (single != null) {
                normalized.add(single);
            }
            return normalized;
        }
        for (String value : values) {
            String normalizedValue = normalizeParam(value);
            if (normalizedValue != null) {
                normalized.add(normalizedValue);
            }
        }
        return normalized;
    }

    private Integer parseMinRating(String value) {
        String normalized = normalizeParam(value);
        if (normalized == null) {
            return null;
        }
        try {
            int rating = Integer.parseInt(normalized);
            if (rating < 1 || rating > 5) {
                return null;
            }
            return rating;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Integer parseOptionalInt(String value) {
        if (value == null) {
            return null;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Category resolveCategory(String categoryParam) {
        if (categoryParam == null) {
            return null;
        }
        Category category = categoryDAO.findBySlug(categoryParam);
        if (category != null) {
            return category;
        }
        try {
            int id = Integer.parseInt(categoryParam);
            return categoryDAO.findById(id);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Brand resolveBrand(String brandParam) {
        if (brandParam == null) {
            return null;
        }
        Brand brand = brandDAO.findBySlug(brandParam);
        if (brand != null) {
            return brand;
        }
        try {
            int id = Integer.parseInt(brandParam);
            return brandDAO.findById(id);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private BigDecimal[] parsePriceRange(String priceRange) {
        BigDecimal min = null;
        BigDecimal max = null;
        try {
            String[] parts = priceRange.split("-");
            if (parts.length > 0 && !parts[0].isBlank()) {
                min = new BigDecimal(parts[0]);
            }
            if (parts.length > 1 && !parts[1].isBlank()) {
                max = new BigDecimal(parts[1]);
            }
        } catch (NumberFormatException e) {
            min = null;
            max = null;
        }
        return new BigDecimal[]{min, max};
    }

    private BigDecimal getProductPrice(Product product) {
        if (product == null) {
            return null;
        }
        ProductVariant variant = product.getDefaultVariant();
        if (variant == null) {
            return null;
        }
        if (variant.getSalePrice() != null && variant.getSalePrice().compareTo(BigDecimal.ZERO) > 0) {
            return variant.getSalePrice();
        }
        return variant.getOriginalPrice();
    }

    private void applySorting(List<Product> products, String sort) {
        String sortKey = sort != null ? sort : "newest";
        Comparator<Product> comparator;
        switch (sortKey) {
            case "name-asc":
                comparator = Comparator.comparing(Product::getProductName,
                        Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER));
                break;
            case "name-desc":
                comparator = Comparator.comparing(Product::getProductName,
                        Comparator.nullsLast(String.CASE_INSENSITIVE_ORDER)).reversed();
                break;
            case "price-asc":
                comparator = Comparator.comparing(this::getProductPrice, Comparator.nullsLast(BigDecimal::compareTo));
                break;
            case "price-desc":
                comparator = Comparator.comparing(this::getProductPrice, Comparator.nullsLast(BigDecimal::compareTo)).reversed();
                break;
            case "rating":
                comparator = Comparator.comparing(this::getSafeRating, Comparator.nullsLast(BigDecimal::compareTo)).reversed()
                        .thenComparing(Product::getReviewCount, Comparator.reverseOrder())
                        .thenComparing(Comparator.comparing(Product::getCreatedAt,
                                Comparator.nullsLast(Comparator.naturalOrder())).reversed());
                break;
            case "bestseller":
                comparator = Comparator.comparingInt(this::getSafeSoldQuantity).reversed()
                        .thenComparing(Comparator.comparing(this::getSafeRating, Comparator.nullsLast(BigDecimal::compareTo)).reversed())
                        .thenComparing(Product::getReviewCount, Comparator.reverseOrder())
                        .thenComparing(Comparator.comparing(Product::getCreatedAt,
                                Comparator.nullsLast(Comparator.naturalOrder())).reversed());
                break;
            case "most-reviewed":
                comparator = Comparator.comparingInt(Product::getReviewCount).reversed()
                        .thenComparing(Comparator.comparing(this::getSafeRating, Comparator.nullsLast(BigDecimal::compareTo)).reversed())
                        .thenComparing(Comparator.comparing(Product::getCreatedAt,
                                Comparator.nullsLast(Comparator.naturalOrder())).reversed());
                break;
            case "discount-desc":
                comparator = Comparator.comparing(this::getDiscountPercent, Comparator.nullsLast(BigDecimal::compareTo)).reversed()
                        .thenComparing(Comparator.comparing(Product::getCreatedAt,
                                Comparator.nullsLast(Comparator.naturalOrder())).reversed());
                break;
            case "stock-desc":
                comparator = Comparator.comparingInt(this::getStockForSort).reversed()
                        .thenComparing(Comparator.comparing(Product::getCreatedAt,
                                Comparator.nullsLast(Comparator.naturalOrder())).reversed());
                break;
            case "featured":
                comparator = Comparator.comparing(Product::isFeatured).reversed()
                        .thenComparing(Comparator.comparing(Product::getCreatedAt,
                                Comparator.nullsLast(Comparator.naturalOrder())).reversed());
                break;
            default:
                comparator = Comparator.comparing(Product::getCreatedAt, Comparator.nullsLast(Comparator.naturalOrder())).reversed();
                break;
        }
        products.sort(comparator);
    }

    private BigDecimal getSafeRating(Product product) {
        if (product == null || product.getAverageRating() == null) {
            return BigDecimal.ZERO;
        }
        return product.getAverageRating();
    }

    private int getSafeSoldQuantity(Product product) {
        if (product == null) {
            return 0;
        }
        return Math.max(0, product.getSoldQuantity());
    }

    private int getStockForSort(Product product) {
        if (product == null) {
            return 0;
        }
        int remaining = product.getRemainingStock();
        if (remaining > 0) {
            return remaining;
        }
        int stock = product.getStockQuantity();
        return Math.max(0, stock);
    }

    private BigDecimal getDiscountPercent(Product product) {
        if (product == null) {
            return BigDecimal.ZERO;
        }
        ProductVariant variant = product.getDefaultVariant();
        if (variant == null) {
            return BigDecimal.ZERO;
        }
        BigDecimal original = variant.getOriginalPrice();
        BigDecimal sale = variant.getSalePrice();
        if (original == null || original.compareTo(BigDecimal.ZERO) <= 0) {
            return BigDecimal.ZERO;
        }
        if (sale == null || sale.compareTo(BigDecimal.ZERO) <= 0 || sale.compareTo(original) >= 0) {
            return BigDecimal.ZERO;
        }
        BigDecimal discount = original.subtract(sale)
                .multiply(BigDecimal.valueOf(100))
                .divide(original, 2, RoundingMode.HALF_UP);
        return discount.max(BigDecimal.ZERO);
    }

    private List<Product> paginate(List<Product> products, int page, int pageSize) {
        if (products.isEmpty()) {
            return List.of();
        }
        int safePage = Math.max(page, 1);
        int fromIndex = (safePage - 1) * pageSize;
        if (fromIndex >= products.size()) {
            return List.of();
        }
        int toIndex = Math.min(fromIndex + pageSize, products.size());
        return products.subList(fromIndex, toIndex);
    }

    private String buildPageTitle(Category category, Brand brand, String search) {
        if (search != null) {
            return "Tìm kiếm: " + search;
        }
        if (category != null) {
            return category.getCategoryName();
        }
        if (brand != null) {
            return brand.getBrandName();
        }
        return "Sản phẩm";
    }

    private String buildQueryString(HttpServletRequest request, Set<String> excludeKeys) {
        StringBuilder builder = new StringBuilder();
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            String key = entry.getKey();
            if (excludeKeys != null && excludeKeys.contains(key)) {
                continue;
            }
            for (String value : entry.getValue()) {
                String normalized = normalizeParam(value);
                if (normalized == null) {
                    continue;
                }
                if (builder.length() > 0) {
                    builder.append("&");
                }
                builder.append(URLEncoder.encode(key, StandardCharsets.UTF_8));
                builder.append("=");
                builder.append(URLEncoder.encode(normalized, StandardCharsets.UTF_8));
            }
        }
        return builder.toString();
    }

    private Map<String, Boolean> toSlugMap(Set<String> slugs) {
        if (slugs == null || slugs.isEmpty()) {
            return Map.of();
        }
        Map<String, Boolean> map = new HashMap<>();
        for (String slug : slugs) {
            map.put(slug, Boolean.TRUE);
        }
        return map;
    }
}
