package com.example.nhom49_webbansanphamchamsoctoc.controller.user;

import com.example.nhom49_webbansanphamchamsoctoc.dao.BrandDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.CategoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Brand;
import com.example.nhom49_webbansanphamchamsoctoc.model.Category;
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
import java.util.List;
import java.util.Map;
import java.util.Objects;

@WebServlet(name = "ProductListController", urlPatterns = {"/products", "/store", "/search", "/ProductList"})
public class ProductListController extends HttpServlet {
    private static final int PAGE_SIZE = 12;

    private ProductService productService;
    private CategoryDAO categoryDAO;
    private BrandDAO brandDAO;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        categoryDAO = new CategoryDAO();
        brandDAO = new BrandDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String categoryParam = normalizeParam(request.getParameter("category"));
        String brandParam = normalizeParam(request.getParameter("brand"));
        String search = normalizeParam(request.getParameter("search"));
        if (search == null) {
            search = normalizeParam(request.getParameter("q"));
        }
        if (search == null) {
            search = normalizeParam(request.getParameter("keyword"));
        }
        String priceRange = normalizeParam(request.getParameter("priceRange"));
        String sort = normalizeParam(request.getParameter("sort"));

        int page = parsePage(request.getParameter("page"));

        Category currentCategory = resolveCategory(categoryParam);
        Brand currentBrand = resolveBrand(brandParam);

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
            if (currentCategory != null && !Objects.equals(product.getCategoryId(), currentCategory.getCategoryId())) {
                continue;
            }
            if (currentBrand != null && !Objects.equals(product.getBrandId(), currentBrand.getBrandId())) {
                continue;
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
            filtered.add(product);
        }

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
        request.setAttribute("currentCategory", currentCategory);
        request.setAttribute("currentBrand", currentBrand);
        request.setAttribute("pageTitle", buildPageTitle(currentCategory, currentBrand, search));
        request.setAttribute("queryString", buildQueryString(request));

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
            case "price-asc":
                comparator = Comparator.comparing(this::getProductPrice, Comparator.nullsLast(BigDecimal::compareTo));
                break;
            case "price-desc":
                comparator = Comparator.comparing(this::getProductPrice, Comparator.nullsLast(BigDecimal::compareTo)).reversed();
                break;
            case "rating":
                comparator = Comparator.comparing(Product::getAverageRating, Comparator.nullsLast(BigDecimal::compareTo)).reversed();
                break;
            case "bestseller":
                comparator = Comparator.comparing(Product::getReviewCount).reversed();
                break;
            default:
                comparator = Comparator.comparing(Product::getCreatedAt, Comparator.nullsLast(Comparator.naturalOrder())).reversed();
                break;
        }
        products.sort(comparator);
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

    private String buildQueryString(HttpServletRequest request) {
        StringBuilder builder = new StringBuilder();
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            String key = entry.getKey();
            if ("sort".equals(key) || "page".equals(key)) {
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
}
