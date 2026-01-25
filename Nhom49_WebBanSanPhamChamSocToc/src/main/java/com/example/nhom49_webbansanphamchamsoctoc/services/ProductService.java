package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductVariantDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductImgDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.CategoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.BrandDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductVariant;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductImage;
import com.example.nhom49_webbansanphamchamsoctoc.util.SlugUtil;

import java.util.List;
import java.util.Map;

/**
 * Service class cho Product business logic
 * Xử lý product retrieval, search, management
 */
public class ProductService {

    private final ProductDAO productDAO;
    private final ProductVariantDAO variantDAO;
    private final ProductImgDAO imageDAO;
    private final CategoryDAO categoryDAO;
    private final BrandDAO brandDAO;

    public ProductService() {
        this.productDAO = new ProductDAO();
        this.variantDAO = new ProductVariantDAO();
        this.imageDAO = new ProductImgDAO();
        this.categoryDAO = new CategoryDAO();
        this.brandDAO = new BrandDAO();
    }


    // Product retrieval methods

    public Product getProductById(int productId) {
        Product product = productDAO.findById(productId);
        if (product != null) {
            enrichProductWithDetails(product);
        }
        return product;
    }

    public Product getProductBySlug(String slug) {
        Product product = productDAO.findBySlug(slug);
        if (product != null) {
            enrichProductWithDetails(product);
        }
        return product;
    }

    public List<Product> getAllProducts(int page, int pageSize) {
        List<Product> products = productDAO.findWithPagination(page, pageSize);
        enrichProductsWithBasicDetails(products);
        return products;
    }

    public List<Product> getAllProducts() {
        List<Product> products = productDAO.findAll();
        enrichProductsWithBasicDetails(products);
        return products;
    }

    public List<Product> getProductsForAdmin(String search, Integer categoryId, Integer brandId, int page, int pageSize) {
        List<Product> products = productDAO.findByFilters(search, categoryId, brandId, page, pageSize);
        enrichProductsWithBasicDetails(products);
        return products;
    }

    public int countProductsForAdmin(String search, Integer categoryId, Integer brandId) {
        return productDAO.countByFilters(search, categoryId, brandId);
    }

    public List<Product> getProductsByBrand(int brandId) {
        List<Product> products = productDAO.findByBrand(brandId);
        enrichProductsWithBasicDetails(products);
        return products;
    }

    public List<Product> searchProducts(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return List.of();
        }
        List<Product> products = productDAO.search(keyword.trim());
        enrichProductsWithBasicDetails(products);
        return products;
    }

    public List<Product> getFeaturedProducts() {
        List<Product> products = productDAO.findFeatured();
        enrichProductsWithBasicDetails(products);
        return products;
    }

    public List<Product> getOnSaleProducts() {
        List<Product> products = productDAO.findOnSale();
        enrichProductsWithBasicDetails(products);
        return products;
    }

    /**
     * Lấy flash sale products.
     */
    public List<Product> getFlashSaleProducts() {
        List<Product> products = productDAO.findFlashSale();
        enrichProductsWithBasicDetails(products);
        return products;
    }

    /**
     * Lấy products by brand.
     */
    public List<Product> getProductsByBrand(int brandId, int page, int pageSize) {
        List<Product> products = productDAO.findByBrandWithPagination(brandId, page, pageSize);
        enrichProductsWithBasicDetails(products);
        return products;
    }

    /**
     * Đếm số sản phẩm theo brand
     */
    public int countProductsByBrand(int brandId) {
        return productDAO.countByBrand(brandId);
    }

    /**
     * Lấy sản phẩm theo category với phân trang.
     */
    public List<Product> getProductsByCategory(int categoryId, int page, int pageSize) {
        List<Product> products = productDAO.findByCategoryWithPagination(categoryId, page, pageSize);
        enrichProductsWithBasicDetails(products);
        return products;
    }

    /**
     * Tính tổng số trang sản phẩm theo category.
     */
    public int getTotalPagesByCategory(int categoryId, int pageSize) {
        int totalProducts = productDAO.countByCategory(categoryId);
        return (int) Math.ceil((double) totalProducts / pageSize);
    }

    /**
     * Tạo product.
     */
    public int createProduct(Product product) {
        if (product == null || !isValidProduct(product)) {
            return -1;
        }

        if (product.getProductSlug() == null || product.getProductSlug().isEmpty()) {
            product.setProductSlug(SlugUtil.generateSlug(product.getProductName()));
        }

        int productId = productDAO.insert(product);
        if (productId > 0) {
            saveVariants(productId, product.getVariants());
        }
        return productId;
    }

    /**
     * Cập nhật product.
     */
    public boolean updateProduct(Product product) {
        if (product == null || product.getProductId() <= 0 || !isValidProduct(product)) {
            return false;
        }

        Product existingProduct = productDAO.findById(product.getProductId());
        if (existingProduct != null && !existingProduct.getProductName().equals(product.getProductName())) {
            product.setProductSlug(SlugUtil.generateSlug(product.getProductName()));
        }

        boolean updated = productDAO.update(product);
        if (!updated) {
            return false;
        }

        if (product.getVariants() != null) {
            variantDAO.deleteByProductId(product.getProductId());
            saveVariants(product.getProductId(), product.getVariants());
        }
        return true;
    }

    /**
     * Xóa product.
     */
    public boolean deleteProduct(int productId) {
        variantDAO.deleteByProductId(productId);
        imageDAO.deleteByProductId(productId);
        return productDAO.delete(productId);
    }

    /**
     * Lấy total pages.
     */
    public int getTotalPages(int pageSize) {
        int totalProducts = productDAO.countAll();
        return (int) Math.ceil((double) totalProducts / pageSize);
    }

    /**
     * Lấy product images.
     *
     * @param productId Tham số đầu vào.
     * @return Kết quả xử lý của phương thức.
     */
    public List<ProductImage> getProductImages(int productId) {
        return imageDAO.findByProductId(productId);
    }

    /**
     * Thực hiện enrich product with details.
     */
    private void enrichProductWithDetails(Product product) {
        List<ProductVariant> variants = variantDAO.findByProductId(product.getProductId());
        List<ProductImage> images = imageDAO.findByProductId(product.getProductId());
        product.setVariants(variants);
        product.setImages(images);
        int remainingStock = 0;
        if (variants != null) {
            for (ProductVariant variant : variants) {
                remainingStock += Math.max(0, variant.getStockQuantity());
            }
        }
        applyStockStats(product, remainingStock);

        // Load category and brand names
        if (product.getCategoryId() != null) {
            var category = categoryDAO.findById(product.getCategoryId());
            if (category != null) {
                product.setCategory(category);
                product.setCategoryName(category.getCategoryName());
            }
        }
        if (product.getBrandId() != null) {
            var brand = brandDAO.findById(product.getBrandId());
            if (brand != null) {
                product.setBrand(brand);
                product.setBrandName(brand.getBrandName());
            }
        }
    }

    /**
     * Thực hiện enrich products with basic details.

     */
    private void enrichProductsWithBasicDetails(List<Product> products) {
        if (products == null || products.isEmpty()) {
            return;
        }
        List<Integer> productIds = products.stream().map(Product::getProductId).toList();
        Map<Integer, Integer> remainingStockMap = variantDAO.getTotalStockByProductIds(productIds);
        for (Product product : products) {
            ProductImage primaryImage = imageDAO.findPrimaryByProductId(product.getProductId());
            if (primaryImage != null) {
                product.setPrimaryImageUrl(primaryImage.getImageUrl());
                product.setImages(List.of(primaryImage));
            }

            ProductVariant defaultVariant = variantDAO.findDefaultByProductId(product.getProductId());
            if (defaultVariant != null) {
                product.setDefaultVariant(defaultVariant);
            }

            if (product.getCategoryId() != null) {
                var category = categoryDAO.findById(product.getCategoryId());
                if (category != null) {
                    product.setCategory(category);
                    product.setCategoryName(category.getCategoryName());
                }
            }
            if (product.getBrandId() != null) {
                var brand = brandDAO.findById(product.getBrandId());
                if (brand != null) {
                    product.setBrand(brand);
                    product.setBrandName(brand.getBrandName());
                }
            }

            int remainingStock = remainingStockMap.getOrDefault(product.getProductId(), 0);
            applyStockStats(product, remainingStock);
        }
    }

    private void applyStockStats(Product product, int remainingStock) {
        if (product == null) {
            return;
        }
        int totalStock = Math.max(0, product.getStockQuantity());
        int remaining = Math.max(0, remainingStock);
        int soldQuantity = Math.max(0, totalStock - remaining);
        if (soldQuantity > totalStock) {
            soldQuantity = totalStock;
        }
        int soldPercent = totalStock > 0 ? (int) Math.round((soldQuantity * 100.0) / totalStock) : 0;

        product.setRemainingStock(remaining);
        product.setSoldQuantity(soldQuantity);
        product.setSoldPercent(soldPercent);
    }

    /**
     * Kiểm tra valid product.
     */
    private void saveVariants(int productId, List<ProductVariant> variants) {
        if (variants == null || variants.isEmpty()) {
            return;
        }

        boolean defaultSet = false;
        for (ProductVariant variant : variants) {
            if (variant.isDefault()) {
                defaultSet = true;
                break;
            }
        }

        for (int i = 0; i < variants.size(); i++) {
            ProductVariant variant = variants.get(i);
            variant.setProductId(productId);
            if (!defaultSet) {
                variant.setDefault(i == 0);
            }
            variantDAO.insert(variant);
        }
    }

    private boolean isValidProduct(Product product) {
        return product.getProductName() != null &&
                !product.getProductName().trim().isEmpty() &&
                product.getProductName().length() <= 255;
    }
}
