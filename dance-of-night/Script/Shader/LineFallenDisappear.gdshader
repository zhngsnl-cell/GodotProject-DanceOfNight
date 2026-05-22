shader_type canvas_item;

// 声明一个 varying 变量，用于把顶点坐标从 vertex 函数传递到 fragment 函数
varying float global_y;

// 接收来自 GDScript 的判定线全局 Y 坐标
uniform float judgment_global_y;

void vertex() {
    // 将顶点的本地坐标转换为全局/画布坐标，并提取 Y 轴
    global_y = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).y;
}

void fragment() {
    // 如果当前像素的全局 Y 坐标超过了判定线（假设向下为正方向）
    if (global_y > judgment_global_y) {
        discard; // 丢弃该像素，使其完全透明
    }
}