package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

import com.cloudinary.utils.ObjectUtils;
import com.example.nhom49_webbansanphamchamsoctoc.dao.BrandDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.CategoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductImgDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductVariantDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Brand;
import com.example.nhom49_webbansanphamchamsoctoc.model.Category;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductImage;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductVariant;
import com.example.nhom49_webbansanphamchamsoctoc.services.ProductService;
import com.example.nhom49_webbansanphamchamsoctoc.util.CloudinaryConfig;
import com.example.nhom49_webbansanphamchamsoctoc.util.SlugUtil;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;

@MultipartConfig
@WebServlet(name = "ProductManagementController", urlPatterns = "/admin/products")
public class ProductManagementController extends HttpServlet {
    private static final int LOW_STOCK_THRESHOLD = 10;

    private final ProductDAO productDAO = new ProductDAO();
    private final ProductVariantDAO productVariantDAO = new ProductVariantDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private final ProductImgDAO productImgDAO = new ProductImgDAO();
    private final ProductService productService = new ProductService();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("get".equals(action)) {
            writeProductJson(request, response);
            return;
        }

        if ("delete".equals(action) || "bulkDelete".equals(action)) {
            response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            return;
        }

        List<Category> categories = categoryDAO.findAll();
        request.setAttribute("categories", categories);

        List<Brand> brands = brandDAO.findAll();
        request.setAttribute("brands", brands);

        if ("edit".equals(action)) {
            int id = parseIntSafe(request.getParameter("id"));
            if (id > 0) {
                Product product = productService.getProductById(id);
                request.setAttribute("product", product);

                List<ProductVariant> variants = productVariantDAO.findByProductId(id);
                request.setAttribute("variants", variants);
            }
            request.getRequestDispatcher("/admin/product/form.jsp").forward(request, response);
            return;
        }

        List<Product> allProducts = productService.getAllProducts();
        ProductStats stats = calculateStats(allProducts);
        List<Product> products = filterProducts(allProducts, request);

        request.setAttribute("totalProducts", stats.total());
        request.setAttribute("sellingProducts", stats.selling());
        request.setAttribute("lowOrOutProducts", stats.lowOrOut());
        request.setAttribute("hiddenProducts", productDAO.countDeleted());
        request.setAttribute("filteredProducts", products.size());
        request.setAttribute("lowStockThreshold", LOW_STOCK_THRESHOLD);
        request.setAttribute("selectedQuery", trim(request.getParameter("q")));
        request.setAttribute("selectedStatus", trim(request.getParameter("status")));
        request.setAttribute("selectedCategoryId", trim(request.getParameter("categoryId")));
        request.setAttribute("selectedBrandId", trim(request.getParameter("brandId")));
        request.setAttribute("selectedStock", trim(request.getParameter("stock")));
        request.setAttribute("selectedAlpha", trim(request.getParameter("alpha")).toUpperCase(Locale.ROOT));
        request.setAttribute("products", products);

        request.getRequestDispatcher("/admin/product/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = parseIntSafe(request.getParameter("id"));
            if (id > 0) {
                productDAO.softDelete(id);
                response.sendRedirect(request.getContextPath() + "/admin/products?deleted=1");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/admin/products?err=1");
            return;
        }

        if ("bulkDelete".equals(action)) {
            String[] ids = request.getParameterValues("selectedProductIds");
            int deletedCount = 0;
            if (ids != null) {
                for (String rawId : ids) {
                    int id = parseIntSafe(rawId);
                    if (id > 0 && productDAO.softDelete(id)) {
                        deletedCount++;
                    }
                }
            }
            response.sendRedirect(request.getContextPath() + "/admin/products?deleted=" + deletedCount);
            return;
        }

        if ("create".equals(action)) {
            try {
                Product p = productFromRequest(request);
                int newId = productDAO.insert(p);

                if (newId <= 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/products?err=1");
                    return;
                }

                saveVariantsFromRequest(request, newId);
                saveImageIfPresent(request, newId);

                response.sendRedirect(request.getContextPath() + "/admin/products?created=1");
                return;
            } catch (Exception ex) {
                ex.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/admin/products?err=1");
                return;
            }
        }

        if ("edit".equals(action)) {
            try {
                int id = parseIntSafe(request.getParameter("id"));

                Product p = productFromRequest(request);
                p.setProductId(id);

                productDAO.update(p);

                productVariantDAO.deleteByProductId(id);
                saveVariantsFromRequest(request, id);

                saveImageIfPresent(request, id);

                if (isJsonRequest(request)) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("""
                            {
                                "success": true
                            }
                            """);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/products?updated=1");
                }
                return;
            } catch (Exception ex) {
                ex.printStackTrace();

                if (isJsonRequest(request)) {
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write("""
                            {
                                "success": false,
                                "message": "Lỗi cập nhật sản phẩm"
                            }
                            """);
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/products?err=1");
                }
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void writeProductJson(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = parseIntSafe(request.getParameter("id"));

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (id <= 0) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid product id\"}");
            return;
        }

        Product product = productService.getProductById(id);

        if (product == null) {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            response.getWriter().write("{\"error\":\"Product not found\"}");
            return;
        }

        Map<String, Object> data = new LinkedHashMap<>();
        data.put("id", product.getProductId());
        data.put("productId", product.getProductId());
        data.put("name", product.getProductName());
        data.put("slug", product.getProductSlug());
        data.put("origin", product.getOrigin());
        data.put("categoryId", product.getCategoryId());
        data.put("brandId", product.getBrandId());
        data.put("shortDescription", product.getShortDescription());
        data.put("fullDescription", product.getFullDescription());
        data.put("ingredients", product.getIngredients());
        data.put("usageInstructions", product.getUsageInstructions());
        data.put("isFeatured", product.isFeatured());
        data.put("isOnSale", product.isOnSale());
        data.put("primaryImageUrl", product.getPrimaryImageUrl());
        data.put("variants", buildVariantJson(product));
        data.put("images", buildImageJson(product));

        response.getWriter().write(gson.toJson(data));
    }

    private List<Map<String, Object>> buildVariantJson(Product product) {
        List<Map<String, Object>> items = new ArrayList<>();
        if (product.getVariants() == null) {
            return items;
        }

        for (ProductVariant variant : product.getVariants()) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("variantId", variant.getVariantId());
            item.put("variantName", variant.getVariantName());
            item.put("sku", variant.getSku());
            item.put("originalPrice", variant.getOriginalPrice());
            item.put("salePrice", variant.getSalePrice());
            item.put("stockQuantity", variant.getStockQuantity());
            item.put("isDefault", variant.isDefault());
            items.add(item);
        }
        return items;
    }

    private List<Map<String, Object>> buildImageJson(Product product) {
        List<Map<String, Object>> items = new ArrayList<>();
        if (product.getImages() == null) {
            return items;
        }

        for (ProductImage image : product.getImages()) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("imageId", image.getImageId());
            item.put("imageUrl", image.getImageUrl());
            item.put("isPrimary", image.isPrimary());
            items.add(item);
        }
        return items;
    }

    private void saveImageIfPresent(HttpServletRequest request, int productId) throws Exception {
        Part imagePart = request.getPart("image");
        if (imagePart == null || imagePart.getSize() <= 0) {
            return;
        }

        String contentType = imagePart.getContentType();
        if (!isAllowedImageType(contentType)) {
            throw new IOException("Unsupported image type: " + contentType);
        }

        byte[] fileBytes = imagePart.getInputStream().readAllBytes();
        String productSlug = resolveProductSlug(productId);
        String publicId = productSlug + "-" + UUID.randomUUID();

        Map<?, ?> result = CloudinaryConfig.getInstance()
                .uploader()
                .upload(
                        fileBytes,
                        ObjectUtils.asMap(
                                "folder", "products",
                                "public_id", publicId,
                                "overwrite", false,
                                "invalidate", true,
                                "resource_type", "image"
                        )
                );

        String secureUrl = (String) result.get("secure_url");
        if (secureUrl == null || secureUrl.isBlank()) {
            throw new IOException("Không lấy được URL ảnh từ Cloudinary");
        }

        productImgDAO.setAllNonPrimary(productId);

        ProductImage img = new ProductImage();
        img.setProductId(productId);
        img.setImageUrl(secureUrl);
        img.setPrimary(true);
        productImgDAO.insert(img);
    }

    private String resolveProductSlug(int productId) {
        Product product = productDAO.findById(productId);
        String slug = product != null ? trim(product.getProductSlug()) : "";
        return slug.isEmpty() ? "product-" + productId : slug;
    }

    private Product productFromRequest(HttpServletRequest request) {
        Product p = new Product();

        String name = trim(request.getParameter("name"));
        String slug = trim(request.getParameter("slug"));

        p.setProductName(name);
        p.setProductSlug(slug.isEmpty() ? SlugUtil.generateSlug(name) : slug);

        p.setOrigin(trim(request.getParameter("origin")));
        p.setShortDescription(trim(request.getParameter("shortDescription")));
        p.setFullDescription(trim(request.getParameter("fullDescription")));
        p.setIngredients(trim(request.getParameter("ingredients")));
        p.setUsageInstructions(trim(request.getParameter("usageInstructions")));
        p.setFeatured("on".equalsIgnoreCase(request.getParameter("isFeatured")));
        p.setOnSale("on".equalsIgnoreCase(request.getParameter("isOnSale")));

        int categoryId = parseIntSafe(request.getParameter("categoryId"));
        if (categoryId > 0) {
            p.setCategoryId(categoryId);
        }

        int brandId = parseIntSafe(request.getParameter("brandId"));
        if (brandId > 0) {
            p.setBrandId(brandId);
        }

        return p;
    }

    private void saveVariantsFromRequest(HttpServletRequest request, int productId) {
        String[] names = request.getParameterValues("variantName[]");
        String[] skus = request.getParameterValues("variantSku[]");
        String[] originalPrices = request.getParameterValues("variantOriginalPrice[]");
        String[] salePrices = request.getParameterValues("variantSalePrice[]");
        String[] stocks = request.getParameterValues("variantStock[]");

        if (names == null || names.length == 0) {
            ProductVariant v = new ProductVariant();
            v.setProductId(productId);
            v.setVariantName("Mặc định");
            v.setOriginalPrice(BigDecimal.ONE);
            v.setSalePrice(null);
            v.setDiscountPercent(0);
            v.setStockQuantity(0);
            v.setDefault(true);
            productVariantDAO.insert(v);
            return;
        }

        for (int i = 0; i < names.length; i++) {
            String name = trim(names[i]);
            if (name.isEmpty()) {
                name = "Mặc định";
            }

            String sku = trim(skus != null && i < skus.length ? skus[i] : null);

            BigDecimal originalPrice = parseBigDecimalSafe(
                    originalPrices != null && i < originalPrices.length ? originalPrices[i] : null);
            if (originalPrice.compareTo(BigDecimal.ZERO) <= 0) {
                originalPrice = BigDecimal.ONE;
            }

            BigDecimal salePrice = parseOptionalBigDecimal(
                    salePrices != null && i < salePrices.length ? salePrices[i] : null);
            if (salePrice != null && salePrice.compareTo(originalPrice) >= 0) {
                salePrice = null;
            }

            int stock = parseIntSafe(stocks != null && i < stocks.length ? stocks[i] : "0");

            ProductVariant v = new ProductVariant();
            v.setProductId(productId);
            v.setVariantName(name);
            v.setSku(sku.isEmpty() ? null : sku);
            v.setOriginalPrice(originalPrice);
            v.setSalePrice(salePrice);
            v.setStockQuantity(Math.max(stock, 0));
            v.setDefault(i == 0);

            int discount = 0;
            if (salePrice != null && salePrice.compareTo(BigDecimal.ZERO) > 0 && salePrice.compareTo(originalPrice) < 0) {
                discount = originalPrice.subtract(salePrice)
                        .multiply(BigDecimal.valueOf(100))
                        .divide(originalPrice, 0, RoundingMode.HALF_UP)
                        .intValue();
            }
            v.setDiscountPercent(discount);

            productVariantDAO.insert(v);
        }
    }

    private ProductStats calculateStats(List<Product> products) {
        if (products == null || products.isEmpty()) {
            return new ProductStats(0, 0, 0);
        }

        int total = products.size();
        int selling = 0;
        int lowOrOut = 0;

        for (Product product : products) {
            int stock = product.getRemainingStock();
            if (stock > 0) {
                selling++;
            }
            if (stock <= LOW_STOCK_THRESHOLD) {
                lowOrOut++;
            }
        }

        return new ProductStats(total, selling, lowOrOut);
    }

    private List<Product> filterProducts(List<Product> products, HttpServletRequest request) {
        List<Product> filtered = new ArrayList<>();
        if (products == null || products.isEmpty()) {
            return filtered;
        }

        String keyword = trim(request.getParameter("q"));
        String status = trim(request.getParameter("status"));
        String stockFilter = trim(request.getParameter("stock"));
        String alpha = trim(request.getParameter("alpha"));
        int categoryId = parseIntSafe(request.getParameter("categoryId"));
        int brandId = parseIntSafe(request.getParameter("brandId"));

        for (Product product : products) {
            if (!matchesKeyword(product, keyword)) {
                continue;
            }
            if (categoryId > 0 && (product.getCategoryId() == null || product.getCategoryId().intValue() != categoryId)) {
                continue;
            }
            if (brandId > 0 && (product.getBrandId() == null || product.getBrandId().intValue() != brandId)) {
                continue;
            }
            if (!matchesStatus(product, status)) {
                continue;
            }
            if (!matchesStock(product, stockFilter)) {
                continue;
            }
            if (!matchesAlpha(product, alpha)) {
                continue;
            }
            filtered.add(product);
        }

        return filtered;
    }

    private boolean matchesKeyword(Product product, String keyword) {
        if (keyword.isEmpty()) {
            return true;
        }

        ProductVariant variant = product.getDefaultVariant();
        String haystack = String.join(" ",
                safe(product.getProductName()),
                safe(product.getProductSlug()),
                safe(product.getBrandName()),
                safe(product.getCategoryName()),
                variant != null ? safe(variant.getSku()) : "");
        return normalizeForSearch(haystack).contains(normalizeForSearch(keyword));
    }

    private boolean matchesStatus(Product product, String status) {
        if (status.isEmpty()) {
            return true;
        }

        return switch (status) {
            case "selling" -> product.getRemainingStock() > 0;
            case "out" -> product.getRemainingStock() <= 0;
            case "sale" -> product.isOnSale();
            default -> true;
        };
    }

    private boolean matchesStock(Product product, String stockFilter) {
        if (stockFilter.isEmpty()) {
            return true;
        }

        int stock = product.getRemainingStock();
        return switch (stockFilter) {
            case "low" -> stock > 0 && stock <= LOW_STOCK_THRESHOLD;
            case "out" -> stock <= 0;
            default -> true;
        };
    }

    private boolean matchesAlpha(Product product, String alpha) {
        if (alpha.isEmpty()) {
            return true;
        }

        String normalizedName = normalizeForSearch(product.getProductName());
        if (normalizedName.isEmpty()) {
            return false;
        }
        return normalizedName.substring(0, 1).equals(alpha.substring(0, 1).toUpperCase(Locale.ROOT));
    }

    private int parseIntSafe(String s) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return -1;
        }
    }

    private BigDecimal parseBigDecimalSafe(String s) {
        try {
            if (s == null) {
                return BigDecimal.ZERO;
            }
            s = s.trim();
            if (s.isEmpty()) {
                return BigDecimal.ZERO;
            }
            return new BigDecimal(s);
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

    private BigDecimal parseOptionalBigDecimal(String s) {
        try {
            if (s == null) {
                return null;
            }
            s = s.trim();
            if (s.isEmpty()) {
                return null;
            }
            BigDecimal value = new BigDecimal(s);
            return value.compareTo(BigDecimal.ZERO) > 0 ? value : null;
        } catch (Exception e) {
            return null;
        }
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private String safe(String value) {
        return value == null ? "" : value;
    }

    private String normalizeForSearch(String value) {
        String normalized = Normalizer.normalize(safe(value), Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .replace('đ', 'd')
                .replace('Đ', 'D');
        return normalized.toLowerCase(Locale.ROOT).trim();
    }

    private boolean isJsonRequest(HttpServletRequest request) {
        String requestedWith = request.getHeader("X-Requested-With");
        String accept = request.getHeader("Accept");
        return "XMLHttpRequest".equalsIgnoreCase(requestedWith)
                || (accept != null && accept.toLowerCase(Locale.ROOT).contains("application/json"));
    }

    private boolean isAllowedImageType(String contentType) {
        return "image/jpeg".equals(contentType)
                || "image/png".equals(contentType)
                || "image/webp".equals(contentType)
                || "image/gif".equals(contentType);
    }

    private record ProductStats(int total, int selling, int lowOrOut) {
    }
}
