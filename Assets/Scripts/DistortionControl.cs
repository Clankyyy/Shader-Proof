using UnityEngine;

public class DistortionControl : MonoBehaviour
{
    [SerializeField] private Material _material;
    [SerializeField, Range(0.01f, 2f)] private float _pointSpeed;

    private const string PROPERTY_KEY = "_PointOffset";
    
    private Vector2 _offset;
    

    private void Update()
    {
        if(_material == null)
            return;
        if (Input.GetKey(KeyCode.UpArrow))
        {
            _offset.y += Time.deltaTime * _pointSpeed;
        }
        if (Input.GetKey(KeyCode.DownArrow))
        {
            _offset.y -= Time.deltaTime * _pointSpeed;
        } 
        if (Input.GetKey(KeyCode.LeftArrow))
        {
            _offset.x -= Time.deltaTime * _pointSpeed;
        } 
        if (Input.GetKey(KeyCode.RightArrow))
        {
            _offset.x += Time.deltaTime * _pointSpeed;
        }
        
        _material.SetVector(PROPERTY_KEY, _offset);
    }
}
