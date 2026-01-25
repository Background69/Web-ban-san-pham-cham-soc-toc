const provinceSelect = document.querySelector('select[name="provinceCode"]');
const districtSelect = document.querySelector('select[name="districtCode"]');
const wardSelect = document.querySelector('select[name="wardCode"]');
const provinceNameInput = document.getElementById('provinceName');
const districtNameInput = document.getElementById('districtName');
const wardNameInput = document.getElementById('wardName');

if (districtSelect) {
    districtSelect.disabled = true;
}
if (wardSelect) {
    wardSelect.disabled = true;
}

// Load tỉnh/thành
if (provinceSelect) {
    fetch('https://provinces.open-api.vn/api/p/')
        .then(res => res.json())
        .then(data => {
            provinceSelect.innerHTML = '<option value="">-- Chọn Tỉnh/Thành phố --</option>';
            data.forEach(p => {
                const opt = document.createElement('option');
                opt.value = p.code;
                opt.textContent = p.name;
                provinceSelect.appendChild(opt);
            });
        });

    provinceSelect.addEventListener('change', () => {
        const provinceCode = provinceSelect.value;
        const provinceName = provinceSelect.options[provinceSelect.selectedIndex]?.text || '';
        if (provinceNameInput) {
            provinceNameInput.value = provinceCode ? provinceName : '';
        }

        if (districtSelect) {
            districtSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
            districtSelect.disabled = true;
        }
        if (wardSelect) {
            wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
            wardSelect.disabled = true;
        }
        if (districtNameInput) {
            districtNameInput.value = '';
        }
        if (wardNameInput) {
            wardNameInput.value = '';
        }

        if (provinceCode && districtSelect) {
            fetch(`https://provinces.open-api.vn/api/p/${provinceCode}?depth=2`)
                .then(res => res.json())
                .then(data => {
                    districtSelect.disabled = false;
                    data.districts.forEach(d => {
                        const opt = document.createElement('option');
                        opt.value = d.code;
                        opt.textContent = d.name;
                        districtSelect.appendChild(opt);
                    });
                });
        }
    });
}

if (districtSelect) {
    districtSelect.addEventListener('change', () => {
        const districtCode = districtSelect.value;
        const districtName = districtSelect.options[districtSelect.selectedIndex]?.text || '';
        if (districtNameInput) {
            districtNameInput.value = districtCode ? districtName : '';
        }

        if (wardSelect) {
            wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
            wardSelect.disabled = true;
        }
        if (wardNameInput) {
            wardNameInput.value = '';
        }

        if (districtCode && wardSelect) {
            fetch(`https://provinces.open-api.vn/api/d/${districtCode}?depth=2`)
                .then(res => res.json())
                .then(data => {
                    wardSelect.disabled = false;
                    data.wards.forEach(w => {
                        const opt = document.createElement('option');
                        opt.value = w.code;
                        opt.textContent = w.name;
                        wardSelect.appendChild(opt);
                    });
                });
        }
    });
}

if (wardSelect) {
    wardSelect.addEventListener('change', () => {
        const wardCode = wardSelect.value;
        const wardName = wardSelect.options[wardSelect.selectedIndex]?.text || '';
        if (wardNameInput) {
            wardNameInput.value = wardCode ? wardName : '';
        }
    });
}
