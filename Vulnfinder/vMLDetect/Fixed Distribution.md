```json
 "inputs": {
    "leakage_report": "/home/zn/work/mlVulnDetect/artifacts/splits/leakage_report.json",
    "prepared_samples": "/home/zn/work/mlVulnDetect/artifacts/data/model-ready/v1/prepared_samples.jsonl",
    "split_policy_version": "clean_split_v1",
    "split_seed": 0,
    "train_ratio": 0.8,
    "val_ratio": 0.1
  },
  "outputs": {
    "rejected_groups_json": "artifacts/splits/clean_split_v1/rejected_groups.json",
    "split_lock_json": "artifacts/splits/clean_split_v1.lock.json",
    "test_jsonl": "artifacts/splits/clean_split_v1/test.jsonl",
    "train_jsonl": "artifacts/splits/clean_split_v1/train.jsonl",
    "val_jsonl": "artifacts/splits/clean_split_v1/val.jsonl"
  },
  "summary": {
    "dataset_distribution": {
      "test": {
        "cvefixes.strict_pair": 92,
        "primevul": 107
      },
      "train": {
        "cvefixes.strict_pair": 8400,
        "cvefixes.weak": 4718,
        "diversevul": 143313,
        "juliet": 227960,
        "primevul": 220471
      },
      "val": {
        "cvefixes.strict_pair": 108,
        "primevul": 45
      }
    },
    "family_distribution": {
      "test": {
        "input_injection_parsing": 4,
        "memory_bounds_lifetime": 127,
        "numeric_size_validation": 8,
        "resource_error_concurrency": 20,
        "unknown": 40
      },
      "train": {
        "auth_access_session": 10035,
        "filesystem_path_config": 3004,
        "input_injection_parsing": 51565,
        "memory_bounds_lifetime": 149333,
        "numeric_size_validation": 47180,
        "resource_error_concurrency": 44417,
        "unknown": 299328
      },
      "val": {
        "memory_bounds_lifetime": 109,
        "numeric_size_validation": 12,
        "resource_error_concurrency": 2,
        "unknown": 30
      }
    },
    "group_counts": {
      "clean_eval_eligible": 389,
      "rejected": 5882,
      "total": 6271
    },
    "label_distribution": {
      "test": {
        "safe": 143,
        "vulnerable": 56
      },
      "train": {
        "safe": 540929,
        "vulnerable": 63933
      },
      "val": {
        "safe": 98,
        "vulnerable": 55
      }
    },
    "sample_counts": {
      "test": 199,
      "train": 604862,
      "val": 153
    }
  }
}
```
 