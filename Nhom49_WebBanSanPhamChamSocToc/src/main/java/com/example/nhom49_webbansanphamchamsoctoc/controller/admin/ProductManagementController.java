package com.example.nhom49_webbansanphamchamsoctoc.controller.admin;

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
import com.example.nhom49_webbansanphamchamsoctoc.util.SlugUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.nio.file.Paths;
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

    private static final String STATIC_PRODUCT_DIR = "/static/assets/images/products/";
    private static final String DB_IMAGE_PREFIX = "images/products/";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = parseIntSafe(request.getParameter("id"));
            if (id > 0) {
                productVariantDAO.deleteByProductId(id);
                productImgDAO.deleteByProductId(id);
                productDAO.delete(id);
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

                ProductVariant def = productVariantDAO.findDefaultByProductId(id);
                request.setAttribute("defaultVariant", def);
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

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            try {
                Product p = productFromRequest(request);
                int newId = productDAO.insert(p);

                if (newId <= 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/products?err=1");
                    return;
                }

                ProductVariant v = variantFromRequest(request);
                v.setProductId(newId);
                v.setDefault(true);
                productVariantDAO.insert(v);

                saveImageIfPresent(request, newId);

                response.sendRedirect(request.getContextPath() + "/admin/products");
                return;
            } catch (Exception ex) {
                response.sendRedirect(request.getContextPath() + "/admin/products?err=1");
                return;
            }
        }

        if ("edit".equals(action)) {
            try {
                int id = parseIntSafe(request.getParameter("id"));
                if (id <= 0) {
                    response.sendRedirect(request.getContextPath() + "/admin/products?err=1");
                    return;
                }

                Product p = productFromRequest(request);
                p.setProductId(id);
                productDAO.update(p);

                ProductVariant def = productVariantDAO.findDefaultByProductId(id);
                if (def != null) {
                    ProductVariant v = variantFromRequest(request);
                    v.setVariantId(def.getVariantId());
                    v.setProductId(id);
                    v.setDefault(true);
                    productVariantDAO.update(v);
                }

                saveImageIfPresent(request, id);

                response.sendRedirect(request.getContextPath() + "/admin/products");
                return;
            } catch (Exception ex) {
                response.sendRedirect(request.getContextPath() + "/admin/products?err=1");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void saveImageIfPresent(HttpServletRequest request, int productId) throws Exception {
        Part imagePart = request.getPart("image");
        if (imagePart == null || imagePart.getSize() <= 0) return;

        String originalName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
        String ext = "";
        int dot = originalName.lastIndexOf('.');
        if (dot >= 0) ext = originalName.substring(dot);

        String savedFileName = UUID.randomUUID().toString().replace("-", "") + ext;

        String realDir = getServletContext().getRealPath(STATIC_PRODUCT_DIR);
        File dir = new File(realDir);
        if (!dir.exists()) dir.mkdirs();

        imagePart.write(realDir + File.separator + savedFileName);

        productImgDAO.setAllNonPrimary(productId);

        ProductImage img = new ProductImage();
        img.setProductId(productId);
        img.setImageUrl(DB_IMAGE_PREFIX + savedFileName);
        img.setPrimary(true);
        productImgDAO.insert(img);
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

        int categoryId = parseIntSafe(request.getParameter("categoryId"));
        if (categoryId > 0) p.setCategoryId(categoryId);

        int brandId = parseIntSafe(request.getParameter("brandId"));
        if (brandId > 0) p.setBrandId(brandId);

        int stockQuantity = parseIntSafe(request.getParameter("stockQuantity"));
        p.setStockQuantity(Math.max(stockQuantity, 0));

        return p;
    }

    private ProductVariant variantFromRequest(HttpServletRequest request) {
        ProductVariant v = new ProductVariant();

        String variantName = trim(request.getParameter("variantName"));
        v.setVariantName(variantName.isEmpty() ? "Mặc định" : variantName);

        BigDecimal original = parseBigDecimalSafe(request.getParameter("originalPrice"));
        BigDecimal sale = parseBigDecimalSafe(request.getParameter("salePrice"));
        int stock = parseIntSafe(request.getParameter("stockQuantity"));

        v.setOriginalPrice(original);
        v.setSalePrice(sale);
        v.setStockQuantity(Math.max(stock, 0));

        int discount = 0;
        if (original.compareTo(BigDecimal.ZERO) > 0
                && sale.compareTo(BigDecimal.ZERO) > 0
                && sale.compareTo(original) < 0) {
            discount = original.subtract(sale)
                    .multiply(BigDecimal.valueOf(100))
                    .divide(original, 0, RoundingMode.HALF_UP)
                    .intValue();
        }
        v.setDiscountPercent(discount);

        return v;
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
            if (s == null) return BigDecimal.ZERO;
            s = s.trim();
            if (s.isEmpty()) return BigDecimal.ZERO;
            return new BigDecimal(s);
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

    private String trim(String s) {
        return s == null ? "" : s.trim();
    }
}
