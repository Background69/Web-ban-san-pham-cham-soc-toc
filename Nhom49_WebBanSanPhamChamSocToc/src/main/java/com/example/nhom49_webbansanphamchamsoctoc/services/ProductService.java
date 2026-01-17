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

    public List<Product> getProductsByCategory(int categoryId, int page, int pageSize) {
        List<Product> products = productDAO.findByCategoryWithPagination(categoryId, page, pageSize);
        enrichProductsWithBasicDetails(products);
        return products;
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
     * Lấy sản phẩm flash sale (giảm giá > 30%)
     */
    public List<Product> getFlashSaleProducts() {
        List<Product> products = productDAO.findFlashSale();
        enrichProductsWithBasicDetails(products);
        return products;
    }

    /**
     * Lấy sản phẩm theo brand với pagination
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


    // Product management methods

    public int createProduct(Product product) {
        if (product == null || !isValidProduct(product)) {
            return -1;
        }

        // Generate slug from product name
        if (product.getProductSlug() == null || product.getProductSlug().isEmpty()) {
            product.setProductSlug(SlugUtil.generateSlug(product.getProductName()));
        }

        return productDAO.insert(product);
    }

    public boolean updateProduct(Product product) {
        if (product == null || product.getProductId() <= 0 || !isValidProduct(product)) {
            return false;
        }

        // Update slug if name changed
        Product existingProduct = productDAO.findById(product.getProductId());
        if (existingProduct != null && !existingProduct.getProductName().equals(product.getProductName())) {
            product.setProductSlug(SlugUtil.generateSlug(product.getProductName()));
        }

        return productDAO.update(product);
    }

    public boolean deleteProduct(int productId) {
        // Delete related data first (variants, images)
        variantDAO.deleteByProductId(productId);
        imageDAO.deleteByProductId(productId);

        return productDAO.delete(productId);
    }

    // Pagination helpers

    public int getTotalPages(int pageSize) {
        int totalProducts = productDAO.countAll();
        return (int) Math.ceil((double) totalProducts / pageSize);
    }

    public int getTotalPagesByCategory(int categoryId, int pageSize) {
        int totalProducts = productDAO.countByCategory(categoryId);
        return (int) Math.ceil((double) totalProducts / pageSize);
    }

    // Product variants

    public List<ProductVariant> getProductVariants(int productId) {
        return variantDAO.findByProductId(productId);
    }

    public ProductVariant getDefaultVariant(int productId) {
        return variantDAO.findDefaultByProductId(productId);
    }

    public ProductVariant getVariantById(int variantId) {
        return variantDAO.findById(variantId);
    }

    // Product images

    public List<ProductImage> getProductImages(int productId) {
        return imageDAO.findByProductId(productId);
    }

    public ProductImage getPrimaryImage(int productId) {
        return imageDAO.findPrimaryByProductId(productId);
    }

    // Helper methods

    private void enrichProductWithDetails(Product product) {
        if (product == null) return;

        // Load variants
        List<ProductVariant> variants = variantDAO.findByProductId(product.getProductId());
        product.setVariants(variants);

        // Load images
        List<ProductImage> images = imageDAO.findByProductId(product.getProductId());
        product.setImages(images);

        // Load category and brand names if needed
        if (product.getCategoryId() != null) {
            var category = categoryDAO.findById(product.getCategoryId());
            if (category != null) {
                product.setCategoryName(category.getCategoryName());
            }
        }

        if (product.getBrandId() != null) {
            var brand = brandDAO.findById(product.getBrandId());
            if (brand != null) {
                product.setBrandName(brand.getBrandName());
            }
        }
    }

    private void enrichProductsWithBasicDetails(List<Product> products) {
        for (Product product : products) {
            // Load primary image only for list view
            ProductImage primaryImage = imageDAO.findPrimaryByProductId(product.getProductId());
            if (primaryImage != null) {
                product.setPrimaryImageUrl(primaryImage.getImageUrl());
            }

            // Load default variant for pricing
            ProductVariant defaultVariant = variantDAO.findDefaultByProductId(product.getProductId());
            if (defaultVariant != null) {
                product.setDefaultVariant(defaultVariant);
            }
        }
    }

    private boolean isValidProduct(Product product) {
        return product.getProductName() != null &&
                !product.getProductName().trim().isEmpty() &&
                product.getProductName().length() <= 255;
    }
}
