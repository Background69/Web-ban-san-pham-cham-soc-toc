package com.example.nhom49_webbansanphamchamsoctoc.services;

import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductVariantDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.ProductImgDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.CategoryDAO;
import com.example.nhom49_webbansanphamchamsoctoc.dao.BrandDAO;
import com.example.nhom49_webbansanphamchamsoctoc.model.Brand;
import com.example.nhom49_webbansanphamchamsoctoc.model.Category;
import com.example.nhom49_webbansanphamchamsoctoc.model.Product;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductVariant;
import com.example.nhom49_webbansanphamchamsoctoc.model.ProductImage;
import com.example.nhom49_webbansanphamchamsoctoc.model.Promotion;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import com.example.nhom49_webbansanphamchamsoctoc.util.SlugUtil;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class ProductService {

    private static final int FEATURED_PRODUCTS_LIMIT = 8;

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

    public List<Product> getProductsForAdmin(String search, Integer categoryId, Integer brandId, int page,
            int pageSize) {
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

        public List<Product> getRelatedProducts(int productId, int categoryId, int limit) {
        List<Product> products = productDAO.findRelatedProducts(productId, categoryId, limit);
        enrichProductsWithBasicDetails(products);
        return products;
    }

    public List<Product> getAllProductsExcludingOnSale() {
        List<Product> products = filterOutOnSale(productDAO.findAll());
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

    public List<Product> searchProductsExcludingOnSale(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return new ArrayList<>();
        }
        List<Product> products = filterOutOnSale(productDAO.search(keyword.trim()));
        enrichProductsWithBasicDetails(products);
        return products;
    }

    public List<Product> getFeaturedProducts() {
        List<Product> products = productDAO.getTopRatedBestSellingProducts(FEATURED_PRODUCTS_LIMIT);
        enrichProductsWithBasicDetails(products);
        return products;
    }

    public List<Product> getFeaturedProductsExcludingOnSale() {
        List<Product> products = filterOutOnSale(productDAO.findFeatured());
        enrichProductsWithBasicDetails(products);
        return products;
    }

    public List<Product> getOnSaleProducts() {
        List<Product> products = productDAO.findOnSale();
        enrichProductsWithBasicDetails(products);
        return products;
    }

    public List<Product> getOnSaleProducts(int limit, int offset) {
        List<Product> products = productDAO.findOnSale(limit, offset);
        enrichProductsWithBasicDetails(products);
        return products;
    }

    public int countOnSaleProducts() {
        return productDAO.countOnSale();
    }

        public List<Product> getFlashSaleProducts() {
        List<Product> products = productDAO.findFlashSale();
        enrichProductsWithBasicDetails(products);
        return products;
    }

        public Product getProductWithPromotions(int productId) {
        Product product = productDAO.findByIdWithRelations(productId);
        if (product != null) {
            enrichProductWithDetails(product);
            calculateFinalPrice(product);
        }
        return product;
    }

        public Product getProductBySlugWithPromotions(String slug) {
        Product product = productDAO.findBySlug(slug);
        if (product != null) {
            Product withRelations = productDAO.findByIdWithRelations(product.getProductId());
            if (withRelations != null) {
                product.setHairConditions(withRelations.getHairConditions());
                product.setPromotions(withRelations.getPromotions());
            }
            enrichProductWithDetails(product);
            calculateFinalPrice(product);
        }
        return product;
    }

        public BigDecimal calculateFinalPrice(Product product) {
        if (product == null) {
            return BigDecimal.ZERO;
        }

        ProductVariant defaultVariant = product.getDefaultVariant();
        BigDecimal finalPrice = BigDecimal.ZERO;
        if (defaultVariant != null) {
            if (defaultVariant.getSalePrice() != null && defaultVariant.getSalePrice().compareTo(BigDecimal.ZERO) > 0) {
                finalPrice = defaultVariant.getSalePrice();
            } else if (defaultVariant.getOriginalPrice() != null) {
                finalPrice = defaultVariant.getOriginalPrice();
            }
        }

        product.setFinalPrice(finalPrice);
        product.setActivePromotion(findFirstActivePromotion(product.getPromotions()));
        return finalPrice;
    }

    private Promotion findFirstActivePromotion(List<Promotion> promotions) {
        if (promotions == null || promotions.isEmpty()) {
            return null;
        }
        LocalDateTime now = LocalDateTime.now();
        for (Promotion promotion : promotions) {
            if (promotion == null || !promotion.isActive() || promotion.getStartDate() == null || promotion.getEndDate() == null) {
                continue;
            }
            if (!now.isBefore(promotion.getStartDate()) && !now.isAfter(promotion.getEndDate())) {
                return promotion;
            }
        }
        return null;
    }

        public List<Product> getProductsByBrand(int brandId, int page, int pageSize) {
        List<Product> products = productDAO.findByBrandWithPagination(brandId, page, pageSize);
        enrichProductsWithBasicDetails(products);
        return products;
    }

        public int countProductsByBrand(int brandId) {
        return productDAO.countByBrand(brandId);
    }

        public List<Product> getProductsByCategory(int categoryId, int page, int pageSize) {
        List<Product> products = productDAO.findByCategoryWithPagination(categoryId, page, pageSize);
        enrichProductsWithBasicDetails(products);
        return products;
    }

        public int getTotalPagesByCategory(int categoryId, int pageSize) {
        int totalProducts = productDAO.countByCategory(categoryId);
        return (int) Math.ceil((double) totalProducts / pageSize);
    }

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

        public boolean deleteProduct(int productId) {
        return productDAO.softDelete(productId);
    }

        public int getTotalPages(int pageSize) {
        int totalProducts = productDAO.countAll();
        return (int) Math.ceil((double) totalProducts / pageSize);
    }

    public List<ProductImage> getProductImages(int productId) {
        return imageDAO.findByProductId(productId);
    }

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

    private List<Product> filterOutOnSale(List<Product> products) {
        List<Product> filtered = new ArrayList<>();
        if (products == null || products.isEmpty()) {
            return filtered;
        }
        for (Product product : products) {
            if (product != null && !product.isOnSale()) {
                filtered.add(product);
            }
        }
        return filtered;
    }

        private void enrichProductsWithBasicDetails(List<Product> products) {
        if (products == null || products.isEmpty()) {
            return;
        }
        List<Integer> productIds = products.stream().map(Product::getProductId).toList();
        Map<Integer, Integer> remainingStockMap = variantDAO.getTotalStockByProductIds(productIds);

        // Tải category và brand theo batch để tránh query lặp
        Map<Integer, Category> categoryMap = categoryDAO.findAll()
                .stream().collect(Collectors.toMap(Category::getCategoryId, c -> c));
        Map<Integer, Brand> brandMap = brandDAO.findAll()
                .stream().collect(Collectors.toMap(Brand::getBrandId, b -> b));

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
                Category category = categoryMap.get(product.getCategoryId());
                if (category != null) {
                    product.setCategory(category);
                    product.setCategoryName(category.getCategoryName());
                }
            }
            if (product.getBrandId() != null) {
                Brand brand = brandMap.get(product.getBrandId());
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
        int remaining = Math.max(0, remainingStock);
        int soldQuantity = Math.max(0, product.getSoldQuantity());
        int totalStock = remaining + soldQuantity;
        int soldPercent = totalStock > 0 ? (int) Math.round((soldQuantity * 100.0) / totalStock) : 0;

        product.setStockQuantity(totalStock);
        product.setRemainingStock(remaining);
        product.setSoldQuantity(soldQuantity);
        product.setSoldPercent(soldPercent);
    }

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



