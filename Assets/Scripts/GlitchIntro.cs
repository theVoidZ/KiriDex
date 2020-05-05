using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;
using Random = UnityEngine.Random;


[System.Serializable]
public class Room
{
    public int roomId;
    public Renderer[] mapElements;
    public Renderer player;
    public Renderer[] collectibles;
    public RawImage[] uiImages;
    public Text[] uiTexts;
    public Text[] uiGlitchedTexts;
    
    public Material[] effects;

}

public class GlitchIntro : MonoBehaviour
{
    public int currentRoomId = 0;
    public Room[] rooms;
    
    public Renderer[] background;
    public Renderer[] foreground;
    public Renderer player;
    public Renderer[] collectibles;
    public Renderer[] ennemies;
    public RawImage[] uiImages;
    public Text[] uiTexts;
    public Text[] uiGlitchedTexts;

    // material list - base
    public Material defaultSpriteMaterial;
    public Material glitchEffect;
    public Material reverseEffect;
    public Material[] effects;
    
    private CameraShake cameraShake;
    private AudioManager audioManager;
    private bool isEffectTriggered = false;
    
    private void Awake()
    {
        SetMaterial(defaultSpriteMaterial);
        audioManager = GetComponent<AudioManager>();
        cameraShake = GetComponent<CameraShake>();

    }

    private void Update()
    {
        if (isEffectTriggered)
        {
            float cursor = Random.Range(0f, 1f);
            glitchEffect.SetFloat("_amount", cursor);

            if (uiGlitchedTexts.Length > 0)
            {
                for( int i=0; i< uiTexts.Length; i++)
                {
                    uiGlitchedTexts[i].text = randomString(uiTexts[i].text, 6);
                    uiTexts[i].enabled = false;
                    uiGlitchedTexts[i].enabled = true;
                }
            }
        }
        else
        {
            for (int i = 0; i < uiTexts.Length; i++)
            {
                uiTexts[i].enabled = true;
                uiGlitchedTexts[i].enabled = false;
            }
        }
    }

    public String randomString(string source, int period )
    {
        string randomstr = "";
        int cursor = (int)Random.Range(0f, 3f);
        for (int i = 0; i < source.Length; i++)
        {
            if (cursor > 0)
            {
                randomstr += source[i];
                cursor--;
                continue;
            }

            cursor = period;
            if ( source[i] == ' ' )
            {
                randomstr += ' ';
            }
            else
            {
                randomstr += (char)Random.Range(0, 255);
            }   
        }

        return randomstr;
    }
    
    public IEnumerator TriggerIntroEffect()
    {
        
        yield return new WaitForSeconds(3f);
        StartCoroutine(ApplyGlitch(false, 0.1f, 2.5f, true, "glitch1", true, 1f, defaultSpriteMaterial) );

        yield return new WaitForSeconds(3f);
        StartCoroutine(ApplyGlitch(false, 0.7f, 2.5f, true, "glitch1", true, 1f, defaultSpriteMaterial) );


        yield return new WaitForSeconds(5f);
        StartCoroutine(ApplyGlitch(true, 0.5f, 7f, true, "glitch3", true, 1f, defaultSpriteMaterial) );        
        
        yield return new WaitForSeconds(4f);
        StartCoroutine(ApplyGlitch(true, 0.3f, 5f, true, "glitch2", false, 1f, defaultSpriteMaterial) );

        for (int i = 0; i < 2; i++)
        {
            yield return new WaitForSeconds(0.7f);
            StartCoroutine(ApplyGlitch(true, 0.3f, 3f, true, "glitch"+(i+1), false, 1f, defaultSpriteMaterial) );

        }
    }

    public IEnumerator TriggerLoopEffect()
    {
        // 
        while (true)
        {
            yield return new WaitForSeconds( Random.Range(4f, 7f) );
            // set new material
            Material loadNext = effects[(int) Random.Range(0f, effects.Length)];

            StartCoroutine(ApplyGlitch(true, Random.Range(0.3f, 1.5f), 3f, true, "glitch"+ (int)Random.Range(1,3), true, Random.Range(0.5f, 2f) , loadNext) );        
        }
    }

    // apply effect Cycle
    public IEnumerator ApplyGlitch( bool applyInitialReverse, float duration, float treshold, bool doShake, string soundclip, bool stopsound, float timeScale, Material loadNext )
    {
        audioManager.PlaySound(soundclip);
        if (applyInitialReverse)
        {
            SetMaterial(reverseEffect);
            yield return new WaitForSeconds(0.2f);
        }
        
        Time.timeScale = timeScale;
        isEffectTriggered = true;
        glitchEffect.SetFloat("_treshold", treshold);
        SetMaterial(glitchEffect);
        if (doShake)
        {
            cameraShake.shakeDuration = duration;
        }
        
        // pre Effect
        yield return new WaitForSeconds(duration*Time.timeScale);
        // post Effect
        
        isEffectTriggered = false;
        Time.timeScale = 1f;
        
        SetMaterial(loadNext);
        if (stopsound)
        {
            audioManager.StopSound(soundclip);
        }

    }

    private void SetMaterial(Material material)
    {
        for (int i = 0; i < background.Length; i++)
        {
            background[i].sharedMaterial = material;
        }
        for (int i = 0; i < foreground.Length; i++)
        {
            foreground[i].sharedMaterial = material;
        }
        player.sharedMaterial = material;
        for (int i = 0; i < collectibles.Length; i++)
        {
            collectibles[i].sharedMaterial = material;
        }

        for (int i = 0; i < ennemies.Length; i++)
        {
            ennemies[i].sharedMaterial = material;
        }
        
        for (int i = 0; i < uiImages.Length; i++)
        {
            uiImages[i].material = material;
        }

    }
}
