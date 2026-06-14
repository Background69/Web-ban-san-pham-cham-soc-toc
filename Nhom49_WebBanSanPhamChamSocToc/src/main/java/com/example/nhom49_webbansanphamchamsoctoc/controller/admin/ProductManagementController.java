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
import java.util.Map;
import java.util.Locale;
import java.util.List;
import java.util.UUID;

@MultipartConfig
@WebServlet(name = "ProductManagementController", urlPatterns = "/admin/products")
public class ProductManagementController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final ProductVariantDAO productVariantDAO = new ProductVariantDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final BrandDAO brandDAO = new BrandDAO();
    private final ProductImgDAO productImgDAO = new ProductImgDAO();
    private final ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("get".equals(action)) {
            int id = parseIntSafe(request.getParameter("id"));
            Product product = productService.getProductById(id);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(
                    "{"
                            + "\"id\":" + product.getProductId() + ","
                            + "\"name\":\"" + product.getProductName() + "\","
                            + "\"slug\":\"" + product.getProductSlug() + "\","
                            + "\"origin\":\"" + product.getOrigin() + "\","
                            + "\"categoryId\":" + product.getCategoryId() + ","
                            + "\"brandId\":" + product.getBrandId() + ","
                            + "\"shortDescription\":\"" + product.getShortDescription() + "\","
                            + "\"fullDescription\":\"" + product.getFullDescription() + "\","
                            + "\"ingredients\":\"" + product.getIngredients() + "\","
                            + "\"usageInstructions\":\"" + product.getUsageInstructions() + "\""
                            + "}"
            );
            return;
        }

        if ("delete".equals(action)) {
            int id = parseIntSafe(request.getParameter("id"));
            if (id > 0) {
                productDAO.softDelete(id);
            }
            response.sendRedirect(request.getContextPath() + "/admin/products");
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

        List<Product> products = productService.getAllProducts();
        request.setAttribute("products", products);

        request.getRequestDispatcher("/admin/product/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

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

                response.sendRedirect(request.getContextPath() + "/admin/products");
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

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                response.getWriter().write("""
            {
                "success": true
            }
        """);

                return;

            } catch (Exception ex) {

                ex.printStackTrace();

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                response.getWriter().write("""
            {
                "success": false,
                "message": "Lỗi cập nhật sản phẩm"
            }
        """);

                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
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
            v.setVariantName("Mac dinh");
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
                name = "Mac dinh";
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

    private boolean isAllowedImageType(String contentType) {
        return "image/jpeg".equals(contentType)
                || "image/png".equals(contentType)
                || "image/webp".equals(contentType)
                || "image/gif".equals(contentType);
    }
}
