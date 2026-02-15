# 🎓 Unsupervised Learning: Student Performance Analysis

<div align="left">
    <img src="https://github.com/user-attachments/assets/05a38582-5ebd-43a9-955a-65ffde7bea71" height="50" alt="SAS" style="margin-right: 20px;" />

</div>
<br/>

**Subject:** Unsupervised Learning / Aprendizaje No Supervisado


**Tools:** SAS (Proc PRINCOMP, Proc FACTOR, Proc CLUSTER, Proc DISCRIM)


**Dataset:** Student Performance (Mathematics & Portuguese)

## 👥 Authors
Project developed by:
* **Pablo Galarón Mateo**

---

This repository features an end-to-end unsupervised learning pipeline applied to student data. The project is divided into two major phases, moving from data structure exploration to advanced population segmentation.

### 🔍 Phase 1: Dimensionality Reduction & Correspondence
* **PCA & Factor Analysis:** Reduced 30+ variables into core factors (e.g., "Family & Social Environment", "Academic Background") to simplify the model without losing information.
* **Simple Correspondence Analysis (SCA):** Explored the relationship between alcohol consumption and health levels through profile plots.

### 🧩 Phase 2: Cluster & Discriminant Analysis
* **Segmentation:** Applied hierarchical (Ward's method) and non-hierarchical (**FASTCLUS with DRIFT**) clustering to identify 4 distinct student profiles.
* **Validation:** Used **Discriminant Analysis** to verify the stability of the clusters, achieving consistent classification rates in both calibration and cross-validation sets.

### 📂 Files in this repo
* `📁 Phase_1_PCA_Factorial/`: SAS code and technical report for dimensionality reduction.
* `📁 Phase_2_Cluster_Discriminant/`: SAS code and report for student segmentation.
* `📊 student-mat.csv / student-por.csv`: Raw data used for the analysis.

---

Este repositorio presenta un flujo completo de aprendizaje no supervisado aplicado a datos de rendimiento estudiantil. El proyecto se divide en dos grandes fases: desde la exploración de la estructura de los datos hasta la segmentación avanzada de la población.

### 🔍 Fase 1: Reducción de Dimensionalidad y Correspondencias
* **ACP y Análisis Factorial:** Reducción de más de 30 variables en factores clave (ej: "Entorno Familiar y Social", "Antecedentes Académicos") para simplificar el modelo sin perder información.
* **Correspondencias Simples:** Exploración de la relación entre el consumo de alcohol y los niveles de salud mediante gráficos de perfiles.

### 🧩 Fase 2: Análisis Clúster y Discriminante
* **Segmentación:** Aplicación de métodos jerárquicos (Ward) y no jerárquicos (**FASTCLUS con DRIFT**) para identificar 4 perfiles de alumnos diferenciados.
* **Validación:** Uso de **Análisis Discriminante** para verificar la estabilidad de los clústeres, logrando tasas de clasificación consistentes tanto en la muestra de calibración como en la validación cruzada.

### 📂 Archivos en este repo
* `📁 Phase_1_PCA_Factorial/`: Código SAS e informe técnico de reducción de datos.
* `📁 Phase_2_Cluster_Discriminant/`: Código SAS e informe de segmentación de alumnos.
