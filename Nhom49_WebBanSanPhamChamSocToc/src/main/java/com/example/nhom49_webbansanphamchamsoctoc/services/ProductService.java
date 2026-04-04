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
import java.util.ArrayList;

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


    public List<Product> getAllProducts() {
        List<Product> products = productDAO.findAll();
        enrichProductsWithBasicDetails(products);
        return products;
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

    public List<Product> getProductsByBrand(int brandId, int page, int pageSize) {
        List<Product> products = productDAO.findByBrandWithPagination(brandId, page, pageSize);
        enrichProductsWithBasicDetails(products);
        return products;
    }

    public int countProductsByBrand(int brandId) {
        return productDAO.countByBrand(brandId);
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

}
