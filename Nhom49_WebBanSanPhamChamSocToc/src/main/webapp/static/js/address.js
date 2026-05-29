(function () {
    'use strict';

    const ctxPath = document.body.dataset.contextPath || '';

    const state = {
        province: { code: '', name: '', fullName: '' },
        district: { code: '', name: '', fullName: '' },
        ward: { code: '', name: '', fullName: '' }
    };

    const refs = {};

    function initRefs() {
        refs.provinceSelect = document.getElementById('addrProvince');
        refs.districtSelect = document.getElementById('addrDistrict');
        refs.wardSelect = document.getElementById('addrWard');

        refs.provinceCodeInput = document.getElementById('provinceCode');
        refs.provinceNameInput = document.getElementById('provinceName');
        refs.districtCodeInput = document.getElementById('districtCode');
        refs.districtNameInput = document.getElementById('districtName');
        refs.wardCodeInput = document.getElementById('wardCode');
        refs.wardNameInput = document.getElementById('wardName');
    }

    class CustomSelect {
        constructor(container, options = {}) {
            this.container = container;
            this.placeholder = options.placeholder || '-- Chọn --';
            this.onSelect = options.onSelect || (() => {});
            this.items = [];
            this.selectedItem = null;
            this.isOpen = false;
            this.isDisabled = true;
            this.isLoading = false;

            this.render();
            this.bindEvents();
        }

        render() {
            this.container.innerHTML = `
                <div class="addr-select-trigger disabled placeholder" tabindex="0" role="combobox" aria-expanded="false">
                    <span class="addr-select-text">${this.placeholder}</span>
                    <svg class="addr-select-arrow" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M5.23 7.21a.75.75 0 011.06.02L10 11.168l3.71-3.938a.75.75 0 111.08 1.04l-4.25 4.5a.75.75 0 01-1.08 0l-4.25-4.5a.75.75 0 01.02-1.06z"/>
                    </svg>
                </div>
                <div class="addr-select-dropdown">
                    <div class="addr-select-search-wrap">
                        <input type="text" class="addr-select-search" placeholder="Tìm kiếm..." autocomplete="off">
                    </div>
                    <div class="addr-select-options"></div>
                </div>
            `;

            this.trigger = this.container.querySelector('.addr-select-trigger');
            this.textEl = this.container.querySelector('.addr-select-text');
            this.dropdown = this.container.querySelector('.addr-select-dropdown');
            this.searchInput = this.container.querySelector('.addr-select-search');
            this.optionsList = this.container.querySelector('.addr-select-options');
        }

        bindEvents() {
            // Toggle dropdown
            this.trigger.addEventListener('click', () => {
                if (this.isDisabled || this.isLoading) return;
                this.isOpen ? this.close() : this.open();
            });

            // Keyboard
            this.trigger.addEventListener('keydown', (e) => {
                if (this.isDisabled || this.isLoading) return;
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    this.isOpen ? this.close() : this.open();
                }
                if (e.key === 'Escape') this.close();
            });

            // Search filter
            this.searchInput.addEventListener('input', () => {
                this.filterOptions(this.searchInput.value);
            });

            // Close on outside click
            document.addEventListener('click', (e) => {
                if (this.isOpen && !this.container.contains(e.target)) {
                    this.close();
                }
            });
        }

        open() {
            if (this.isDisabled || this.isLoading) return;
            this.isOpen = true;
            this.container.classList.add('open');
            this.trigger.classList.add('focus');
            this.trigger.setAttribute('aria-expanded', 'true');
            this.searchInput.value = '';
            this.filterOptions('');
            setTimeout(() => this.searchInput.focus(), 50);
        }

        close() {
            this.isOpen = false;
            this.container.classList.remove('open');
            this.trigger.classList.remove('focus');
            this.trigger.setAttribute('aria-expanded', 'false');
        }

        setItems(items) {
            this.items = items || [];
            this.selectedItem = null;
            this.renderOptions(this.items);
            this.setDisabled(false);
            this.setLoading(false);
            this.resetText();
        }

        renderOptions(itemsToShow) {
            if (!itemsToShow.length) {
                this.optionsList.innerHTML = '<div class="addr-select-option no-results">Không tìm thấy kết quả</div>';
                return;
            }

            this.optionsList.innerHTML = itemsToShow.map(item =>
                `<div class="addr-select-option ${this.selectedItem && this.selectedItem.code === item.code ? 'selected' : ''}"
                      data-code="${item.code}"
                      data-name="${item.name}"
                      data-fullname="${item.fullName}">${item.fullName}</div>`
            ).join('');

            // Option click handler
            this.optionsList.querySelectorAll('.addr-select-option:not(.no-results)').forEach(opt => {
                opt.addEventListener('click', () => {
                    const code = opt.dataset.code;
                    const name = opt.dataset.name;
                    const fullName = opt.dataset.fullname;
                    this.selectItem({ code, name, fullName });
                });
            });
        }

        filterOptions(query) {
            const q = this.removeDiacritics(query.toLowerCase().trim());
            if (!q) {
                this.renderOptions(this.items);
                return;
            }
            const filtered = this.items.filter(item => {
                const text = this.removeDiacritics(item.fullName.toLowerCase());
                return text.includes(q);
            });
            this.renderOptions(filtered);
        }

        selectItem(item) {
            this.selectedItem = item;
            this.textEl.textContent = item.fullName;
            this.trigger.classList.remove('placeholder');
            this.trigger.classList.add('has-value');

            // Update selected visual
            this.optionsList.querySelectorAll('.addr-select-option').forEach(opt => {
                opt.classList.toggle('selected', opt.dataset.code === item.code);
            });

            this.close();
            this.onSelect(item);
        }

        resetText() {
            this.textEl.textContent = this.placeholder;
            this.trigger.classList.remove('has-value');
            this.trigger.classList.add('placeholder');
            this.selectedItem = null;
        }

        setDisabled(disabled) {
            this.isDisabled = disabled;
            this.trigger.classList.toggle('disabled', disabled);
            if (disabled) this.close();
        }

        setLoading(loading) {
            this.isLoading = loading;
            this.trigger.classList.toggle('loading', loading);
            if (loading) {
                this.textEl.textContent = 'Đang tải...';
                this.trigger.classList.add('placeholder');
                this.trigger.classList.remove('has-value');
            }
        }

        reset(placeholderText) {
            if (placeholderText) this.placeholder = placeholderText;
            this.items = [];
            this.selectedItem = null;
            this.optionsList.innerHTML = '';
            this.resetText();
            this.setDisabled(true);
            this.setLoading(false);
            this.close();
        }

        getValue() {
            return this.selectedItem;
        }

        removeDiacritics(str) {
            return str.normalize('NFD').replace(/[\u0300-\u036f]/g, '')
                      .replace(/đ/g, 'd').replace(/Đ/g, 'D');
        }
    }


    async function fetchJSON(url) {
        const res = await fetch(url);
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        return res.json();
    }

    async function loadProvinces() {
        if (!refs.provinceSelect) return;

        provinceCS.setLoading(true);
        districtCS.reset('-- Chọn Quận/Huyện --');
        wardCS.reset('-- Chọn Phường/Xã --');
        clearHidden();

        try {
            const data = await fetchJSON(`${ctxPath}/api/provinces`);
            provinceCS.setItems(data);
        } catch (e) {
            console.error('Lỗi tải danh sách tỉnh:', e);
            provinceCS.reset('Lỗi tải dữ liệu');
        }
    }

    async function loadDistricts(provinceCode) {
        districtCS.setLoading(true);
        wardCS.reset('-- Chọn Phường/Xã --');
        clearHidden('district');

        try {
            const data = await fetchJSON(`${ctxPath}/api/districts?provinceCode=${provinceCode}`);
            districtCS.setItems(data);
        } catch (e) {
            console.error('Lỗi tải danh sách quận/huyện:', e);
            districtCS.reset('Lỗi tải dữ liệu');
        }
    }

    async function loadWards(districtCode) {
        wardCS.setLoading(true);
        clearHidden('ward');

        try {
            const data = await fetchJSON(`${ctxPath}/api/wards?districtCode=${districtCode}`);
            wardCS.setItems(data);
        } catch (e) {
            console.error('Lỗi tải danh sách phường/xã:', e);
            wardCS.reset('Lỗi tải dữ liệu');
        }
    }


    function setHidden(level, code, name) {
        if (level === 'province' || level === 'all') {
            if (refs.provinceCodeInput) refs.provinceCodeInput.value = code || '';
            if (refs.provinceNameInput) refs.provinceNameInput.value = name || '';
        }
        if (level === 'district' || level === 'all') {
            if (refs.districtCodeInput) refs.districtCodeInput.value = code || '';
            if (refs.districtNameInput) refs.districtNameInput.value = name || '';
        }
        if (level === 'ward' || level === 'all') {
            if (refs.wardCodeInput) refs.wardCodeInput.value = code || '';
            if (refs.wardNameInput) refs.wardNameInput.value = name || '';
        }
    }

    function clearHidden(fromLevel) {
        if (!fromLevel || fromLevel === 'province') {
            setHidden('province', '', '');
            setHidden('district', '', '');
            setHidden('ward', '', '');
        } else if (fromLevel === 'district') {
            setHidden('district', '', '');
            setHidden('ward', '', '');
        } else if (fromLevel === 'ward') {
            setHidden('ward', '', '');
        }
    }

    let provinceCS, districtCS, wardCS;

    function init() {
        initRefs();
        if (!refs.provinceSelect) return;

        provinceCS = new CustomSelect(refs.provinceSelect, {
            placeholder: '-- Chọn Tỉnh/Thành phố --',
            onSelect: (item) => {
                state.province = item;
                setHidden('province', item.code, item.fullName);
                loadDistricts(item.code);
            }
        });

        districtCS = new CustomSelect(refs.districtSelect, {
            placeholder: '-- Chọn Quận/Huyện --',
            onSelect: (item) => {
                state.district = item;
                setHidden('district', item.code, item.fullName);
                loadWards(item.code);
            }
        });

        wardCS = new CustomSelect(refs.wardSelect, {
            placeholder: '-- Chọn Phường/Xã --',
            onSelect: (item) => {
                state.ward = item;
                setHidden('ward', item.code, item.fullName);
            }
        });

        loadProvinces();
    }

    window.addressModule = {
        init: init,
        loadProvinces: loadProvinces,
        getState: () => ({ ...state })
    };

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
